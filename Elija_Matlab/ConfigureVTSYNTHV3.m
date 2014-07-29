function params = ConfigureVTSYNTHV3(params)
% configure vt model from VTSYNTH dll

disp ('Running ConfigureVTSYNTH v3');

% Initialize RAND to a different state each time.
rand('state',sum(100*clock));

% Initialize RAND to a different state each time.
randn('state',sum(100*clock));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% add path for VTSynth and talkinghead
addpath('..\..\vtsynth\DLLS');

% vtsynth DLL filename
params.libname =  'VSYNTH2';
params.version=3;

% vtsynth DLL filename
params.thlibname = 'TALKINGHEAD';

% parameters VTS_Initialise
% new settings
params.VTdownsample =1;                         % downsampling factor for VT params
params.blockShift = 3 * 80;                     % interpolation factor for  babble generated VT params to achieve speech rate
params.recognitionShift = 3 * 80;               % interpolation factor from vocoder recognizer generated VT params to achieve speech rate

% need to trhow away start and ending due to synthesisre init and ending
% effect
params.cutStartVocoderFrames = 20;
params.cutEndVocoderFrames = 5;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% interpolation parameters
params.interpolationNone                = 1;
params.interpolationLinear              = 2;
params.interpolationCosine              = 3;
params.interpolationCriticalDamping     = 4;

%params.interpolationMode = params.interpolationNone;
%params.interpolationMode = params.interpolationLinear;
%params.interpolationMode = params.interpolationCosine;
params.interpolationMode = params.interpolationCriticalDamping;

% vocal tract size flags 
VTS_SIZE_MALE       =   0;
VTS_SIZE_FEMALE     =   1;
VTS_SIZE_CHILD      =   2;
params.VTsize = VTS_SIZE_CHILD;

params.samplerate   = 24000;                    % speech signal sampling rate; 24k gives better Fx

params.framerate    = params.samplerate/params.blockShift;      % vocoder analysis framerate and also VT param rate
params.decimation   = 1;                          % decimation factor
params.wavBits      = 16; 

% infant/boy definitions
params.vtParamsInfant = 1;
params.vtParamsBoy = 2;

% with one time parameter for all articulators
params.vtParamsInfantTP1 = 3;
params.vtParamsBoyTP1 = 4;

% with start and duration time parameter for each articulator
params.vtParamsInfantTPSD = 5;
params.vtParamsBoyTPSD = 6;
params.vtParamsInfantTPSD_BREATH = 7;
params.vtParamsBoyTPSD_BREATH = 8;

% simple one target for steady state learning
params.vtParamsOneTarget = 9;

params.utilityWeighingVectorLen=27;

% one C target to learn and other V fixed at start
params.vtParamsCrandV = 10;
params.vtParamsVCrand = 11;

% with durations, betas, types
params.vtParamsCrandVDBT = 12;
params.vtParamsVCrandDBT =13;
params.vtParamsOneTargetFixDur = 14;
params.vtParamsCrandVDBTFixDur = 15;

% full parameter set format
% with durations, betas, types and with start and duration time parameter for each articulator
params.vtParamsFullSet = 16;
% with fixed durations to minimize variability
params.vtParamsFullSetFixDur = 17;

% full LINEAR parameter set format -  does not need uppacking!!!
% with durations, betas, types and with start and duration time parameter for each articulator
params.vtParamsFullLinearSet = 18;
% with fixed durations to minimize variability
params.vtParamsFullLinearSetFixDur = 19;

% defined values for VTS_AcousticAnalysis
VTS_THIRDOCTAVE	=	1;		% third octave filters 
VTS_FX			=	2;		% perform autocorrelation fx estimation 
VTS_VDEGREE		=	4;		% perform voicing dgree analysis 
VTS_MEANENERGY	=	8;		% treat overall energy as separate parameter 
VTS_VOCODER		=	16;		% auditory filterbank 
VTS_PRINT		=	1024;	% print the analysis 
VTS_RESPONSE	=	2048;	% dump the filter response 

% parameters for VTS_AcousticAnalysis
params.nanal = 21;                                                                      % analysis channels
params.flags =  VTS_THIRDOCTAVE + VTS_MEANENERGY + VTS_FX + VTS_VDEGREE + VTS_VOCODER;   % analysis options
params.lofreq = 100;                                                                    % low band frequency
params.hifreq = 4000;                                                                   % high band frequency                
params.analLength = params.nanal;                                                       % maximum analysis  buffer size

% plot degugging options
params.wantVocoderCoeffs    =0;
params.wantMeanEnergy       =0;
params.wantFx               =0;
params.wantDegreeOfVoicing  =0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VTSYNTH
if   ~libisloaded(params.libname)
    % To load the library, specify the name of the DLL and the name of the
    % header file. If no file extensions are provided (as below)
    % LOADLIBRARY assumes that the DLL ends with .dll and the header file
    % ends with .h.
    loadlibrary(params.libname, params.libname);
    disp(['Loaded library: ' params.libname]);
    pause(1);
    
end
if ~libisloaded(params.libname)
    error(['Failed to load external library: ' params.libname]);
    success=0;
    return;

else

    % list the methods
    libfunctions(params.libname);   
    pause(1);

    % Initialisation  
    % Parameters:
	% samprate
    % Input frame rate and output sample rate.  This is the basic rate at which articulatory 
    % parameters are specified and acoustic samples are generated per second.
	% decimation
    % Decimation.  This controls the degree of parameter interpolation within a single
    % synthesis frame.  The internal simulation rate will be samprate*decimation.  Decimations 
    % of 2 or 3 are commonly used.
    % Return code:
	% 0	success
    % else	error code    
          
    failed = calllib(params.libname, 'VTS_Initialise', params.samplerate, params.decimation, params.VTsize);
    pause(1);
    if(failed)
        error(['VTS_Initialise failed: ' params.libname]);
        success=0;
        return;
    end    
        
	% configure acoustic analysis    
    % This function sets up the acoustic analysis of the synthetic output.  The flags parameter 
    % controls the type of analysis, e.g. FFT, Auditory filterbank,
    % third-octave filterbank.
    % Parameters:
    % flags 	
    %    Type of analysis: VTS_FFT, VTS_AUDITORY, VTS_THIRD.  Also can 'OR' in values for Fx, 
    %   VTS_FX, and degree of voicing, VTS_VDEGREE.
    % size
	%   Number of output parameters required
	% lofreq
	%	Lowest frequency to be analysed
	% hifreq
    %	Highest freqency to be analysed
    % Return code:
	% 0	Success
	% Else	Error code
  
  	failed = calllib(params.libname, 'VTS_AcousticAnalysis', params.flags, params.nanal, params.lofreq, params.hifreq);
    pause(1);
    if(failed)
        error(['VTS_AcousticAnalysis failed: ' params.libname]);
    end    
        
    % Get version
    version=0;
    date=0;
  	[failed, version, date] = calllib(params.libname, 'VTS_GetVersion', version, date);    
    pause(1);
    if(failed)
        error(['VTS_GetVersion failed: ' params.libname]);        
    end 
    comment=sprintf('Version: %d  Date: %d', version, date);
    disp(comment);     
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 1000 sample onset offset ramp on time signls
params.SpeechOnsetOffsetDuration = 500;
params.VTOnsetOffsetDuration = 25;

% filterMode = 0 for no filter
% filterMode = 1 for median filter
% filterMode = 2 for butterworth LPF
params.filtermode = 0;

% choose existing path for matlab 
matlabPath = '.';
if (exist('U:\MyWork\matlab') == 7)
    matlabPath = 'U:\MyWork\matlab';
end    
if (exist('C:\Documents and Settings\Ian Howard\My Documents\MyWork\matlab') == 7)
    matlabPath = 'C:\Documents and Settings\Ian Howard\My Documents\MyWork\matlab';
end
if (exist('C:\Documents and Settings\IAH\My Documents\MyWork\matlab') == 7)
    matlabPath = 'C:\Documents and Settings\IAH\My Documents\MyWork\matlab';
end


% use the netlist toolbox
IAHMLPlistPath = sprintf('%s\\IAHMLP', matlabPath);
addpath(IAHMLPlistPath);




