function sensoryConsequences = AnalyseSensoryConsequences(params, vtpars, debug)
% run synhtesis and analysis of sensory consequences

% This function clears internal memories and resets dynamic parameters 
calllib(params.libname,'VTS_Reset', -1);    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
% now upsample using linear interpolation to speech rate
% and then synthesise speech output from parameter trajectory
params.wantInit=0;
[outputBuffer, VTP, TubeCSA]  = InterpolatedResynthV2(params, vtpars', params.blockShift);

% if now debug analysis wanted exit
% for example dont debug on hugh files, not enough memory!
if(debug==1)
    sensoryConsequences.outputBuffer=outputBuffer;
    sensoryConsequences.VTP = VTP(:,params.cutStartVocoderFrames:end);
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% low-pass filter speech 

%[B,A] = BUTTER(N,Wn,'high') designs an Nth order highpass digital
%Butterworth filter and returns the filter coefficients in length 
%N+1 vectors B (numerator) and A (denominator). The coefficients 
%are listed in descending powers of z. The cutoff frequency 
%Wn must be 0.0 < Wn < 1.0, with 1.0 corresponding to 
%half the sample rate.

% use 2th order order
[BL,AL] = butter(params.infantConductionLPFpoles,(2 * params.infantConductionLPFcutoff/params.samplerate), 'low');
%FREQZ(B,A,128, params.samplerate);
    
% linear HPF
% Y = FILTER(B,A,X) filters the data in vector X with the
% filter described by vectors A and B to create the filtered
% data Y.             
LPFoutputBuffer= filter(BL,AL,outputBuffer);      


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    

% use 2th order order
[BL,AL] = butter(params.infantConductionLPFpoles,(2 * params.spectralBalanceLF/params.samplerate), 'low');
%FREQZ(BL,AL,128, params.samplerate);
    
% use 2th order order
[BH,AH] = butter(params.infantConductionLPFpoles,(2 * params.spectralBalanceLF/params.samplerate), 'high');
%FREQZ(BH,AH,128, params.samplerate);

% linear HPF
% Y = FILTER(B,A,X) filters the data in vector X with the
% filter described by vectors A and B to create the filtered
% data Y.             
SB_LPFoutputBuffer= filter(BL,AL,outputBuffer);      
SB_HPFoutputBuffer= filter(BH,AH,outputBuffer);      

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
% discard first and last frames
% to get rid of glitches 
cutend = params.cutEndVocoderFrames * params.samplerate/params.framerate;
cutstart = params.cutStartVocoderFrames * params.samplerate/params.framerate;

% cut
outputBuffer = outputBuffer(:,cutstart: (end-cutend));
LPFoutputBuffer = LPFoutputBuffer(:,cutstart: (end-cutend));

SB_LPFoutputBuffer = SB_LPFoutputBuffer(:,cutstart: (end-cutend));
SB_HPFoutputBuffer = SB_HPFoutputBuffer(:,cutstart: (end-cutend));

% smooth out onset and offset on speech
outputBuffer = SmoothOnsetOffsetV2(outputBuffer, params.SpeechOnsetOffsetDuration);
sensoryConsequences.LPFoutputBuffer = SmoothOnsetOffsetV2(LPFoutputBuffer, params.SpeechOnsetOffsetDuration);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
% get window for short-term analysis
win = hanning(1024);
shift = params.samplerate/params.framerate;

% compute short term power on LPF speech bandwidth
SB_LPFoutputPower = GetShortTermPower(SB_LPFoutputBuffer, win, shift);
SB_HPFoutputPower = GetShortTermPower(SB_HPFoutputBuffer, win, shift);

% dont LPF
LPFSTPower = GetShortTermPower(outputBuffer, win, shift);
    
% find out if nasal present
sz=size(vtpars(10,:));
sensoryConsequences.nasal = zeros(sz);
fidx= find(vtpars(10,:) > params.nasalThreshold);
sensoryConsequences.nasal(fidx) = 1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
% compute short term contact
% this puts a non-linearity into the tube cross sectional area signal
[VectorContact, ScalarContact]  = GetShortTermContact(TubeCSA, params.contactThreshold,  0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% high-pass filter contact 

%[B,A] = BUTTER(N,Wn,'high') designs an Nth order highpass digital
%Butterworth filter and returns the filter coefficients in length 
%N+1 vectors B (numerator) and A (denominator). The coefficients 
%are listed in descending powers of z. The cutoff frequency 
%Wn must be 0.0 < Wn < 1.0, with 1.0 corresponding to 
%half the sample rate.

% use 2th order order
[BH,AH] = butter(params.infantContactHPFpoles,(2 * params.infantContactHPF/params.framerate), 'high');
%FREQZ(B,A,128, params.samplerate);
    
% linear HPF
% Y = FILTER(B,A,X) filters the data in vector X with the
% filter described by vectors A and B to create the filtered
% data Y.
for fidx = 1:size(VectorContact,1)
    HPFSTContact(fidx,:)= filter(BH,AH,VectorContact(fidx,:));      
end

% set lengths to same
len(1) = size(VectorContact,2)-params.cutEndVocoderFrames;
len(2) = size(VTP,2)-params.cutEndVocoderFrames;
minlen=min(len);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% return analysis

sensoryConsequences.outputBuffer=outputBuffer;
sensoryConsequences.VTP = VTP(:,params.cutStartVocoderFrames:minlen);

sensoryConsequences.VectorContact = VectorContact(:,params.cutStartVocoderFrames:minlen);
sensoryConsequences.SumContact = sum(sensoryConsequences.VectorContact,1);


sensoryConsequences.TubeCSA = TubeCSA(:,params.cutStartVocoderFrames:minlen);

sensoryConsequences.HPFSTContact = abs(HPFSTContact(:,params.cutStartVocoderFrames:minlen));
sensoryConsequences.LPFSTPower = LPFSTPower(:,:);

sensoryConsequences.SB_LPFoutputPower = SB_LPFoutputPower;
sensoryConsequences.SB_HPFoutputPower = SB_HPFoutputPower;

% Calculate STFT features of infant speech
sensoryConsequences.STFT = abs(auditoryFilterbank(outputBuffer, params.samplerate));

% compute absolute value of difference
AADiff = abs(sensoryConsequences.STFT(:,2:end) - sensoryConsequences.STFT(:,1:end-1));
        
% compute mean to give overall frame difference
sensoryConsequences.spectrogramNDiffF = mean(AADiff,1);                
      
% return mean over utterance frames to compute mean touch for each tube section
sensoryConsequences.ppParams = mean(sensoryConsequences.VectorContact,2);

% TEST
sensoryConsequences.scParams = 0;
return

% look at middle 1/3 to avoid transient effects    
len = size(sensoryConsequences.STFT,2);
startIdx = floor(len/3);        
endIdx = floor(2 * len/3);     
sensoryConsequences.scParams = mean(sensoryConsequences.STFT(:, startIdx:endIdx),2);

if(debug)
    
    figure
    hold on
    title('Auditory filterbank');
    imagesc(sensoryConsequences.STFT);
    legend('Auditory filterbank');
    % build and use a grey scale
    lgrays=zeros(100,3);
    for i=1:100
        lgrays(i,:) = 1-i/100;
    end
    colormap(lgrays);    
    % label plot
    axis xy;
    xlabel('Time frame');
    ylabel('Frequency band)');

    if(0)
    figure
    hold on
    plot(sensoryConsequences.outputBuffer(1,1:240:end),'b.-');
    plot(sensoryConsequences.LPFSTPower,'rx-');
    plot(sensoryConsequences.SB_LPFoutputPower,'go-');
    plot(sensoryConsequences.SB_HPFoutputPower,'b+-');           
    plot(sensoryConsequences.spectrogramNDiffF,'k.-');
    plot(sensoryConsequences.SumContact,'y.-');
    %plot(sensoryConsequences.nasal,'k:');

    legend('Speech', 'Power',  'LPFoutputPower', 'HPFoutputPower', 'SpectralChange', 'SumContact');
    title('Plots of Speech, Power and Proprioception');
    end
end
