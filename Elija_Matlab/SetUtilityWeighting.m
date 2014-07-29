function params = SetUtilityWeighting(params, utilityWeighing)
% set weigting factors for loss function


% contact: in particular
% Want touch at lips - 17
% Want touch at tongue tip  back of teeth - 15
% Want touch at tongue tip at alveolar ridge - 14
% Want touch at tongue tip at top of palette - 8 to 13
% Pharyngeal constriction - 2
for idx=1:17
    % want to find a construction
    params.weight.STContact(idx) = utilityWeighing(idx);
end

% Want acoustic power (minus for dont want acoustic power)
params.weight.LPFSTPower = utilityWeighing(18);

% Want spectral change (minus for dont want spectral change)
params.weight.spectrogramNDiffF =  utilityWeighing(19);

% Want Voicing on 
params.weight.voicing = utilityWeighing(20);

% Articulator Effort -ve
params.weight.vocalEffort = utilityWeighing(21);

% Voicing Effort -ve
params.weight.overallArticulatorEffort = utilityWeighing(22);

% Nasal
params.weight.nasal = utilityWeighing(23);
params.nasalThreshold = 0.0;

% LFversusHF
params.weight.LFversusHF = utilityWeighing(24);
params.weight.HFversusLF = utilityWeighing(25);

% multiple tongue contacts
params.weight.multipleTongueContacts = utilityWeighing(26);
params.weight.contactThreshold=2;

% want minimum locatiuon
params.weight.tubeMinimum = utilityWeighing(27);


% was 40
% but now params.beta = 40 * params.blockShift; 
params.beta = 4000; 

% was 10
params.betaScalePlosive=2;
params.betaScaleNormal=1;
params.betaScaleNasal=5;

% different value for each articulator
params.betaTPSD(1) = 16000 * params.betaScale;% was 4000
params.betaTPSD(2) = 4000 * params.betaScale;
params.betaTPSD(3) = 4000 * params.betaScale;
params.betaTPSD(4) = 4000 * params.betaScale;
params.betaTPSD(5) = 4000 * params.betaScale;
params.betaTPSD(6) = 4000 * params.betaScale;
params.betaTPSD(7) = 4000 * params.betaScale;
params.betaTPSD(8) = 8000 * params.betaScale; % faster vx changes
%params.betaTPSD(9) = 2000 * params.betaScale;   % slower fx changes  
%params.betaTPSD(10) = 400 * params.betaScale; % slower Nx changes - was 4000
params.betaTPSD(9) = 4000 * params.betaScale;   % slower fx changes  
params.betaTPSD(10) = 2000 * params.betaScale; % slower Nx changes - was 4000
% p1 Jaw position
% p2 Tongue dorsum position
% p3 Tongue dorsum shape
% p4 Tongue apex position
% p5 Lip height (aperture)
% p6 Lip protrusion
% p7 Larynx height
% p8 Voicing
% p9 Fundamental frequency
% p10 Breathing

% filtering for feedback speech
params.infantConductionLPFcutoff = 800;      
params.infantConductionLPFpoles = 2;        

% contact high pass filering
params.infantContactHPFpoles = 2;
params.infantContactHPF = 1; % was 4

% proprioceptive signal contact threshold for area functrion
params.contactThreshold = 0.01;

% spectral balance frequencies
% was 6000, which was rather high
params.spectralBalanceLF=4000;
params.spectralBalanceHF=4000;    


% limit on parameters in Madea space
% params.vtParamsLimit = 0.75;
params.vtParamsLimit = 1.0;

% smooth offset, 100ms at 24KHz
params.SmoothOnsetOffsetSamples = 2400;
  
% put limit on articulator durations
params.vtParamsLimitDmax = 0.5;
params.vtParamsLimitDmin = 0.3;

% put limit on articulator durations
params.vtParamsLimitDmaxCV = 0.4;
params.vtParamsLimitDminCV = 0.3;

params.vtParamsLimitDmaxCVStart = 0.2;
params.vtParamsLimitDminCVStart = 0.2;

params.vtParamsLimitDmaxVVStart = 0.4;
params.vtParamsLimitDminVVStart = 0.4;

params.vtParamsLimitDmaxNVStart = 0.4;
params.vtParamsLimitDminNVStart = 0.4;

params.vtParamsLimitDmaxFVStart = 0.5;
params.vtParamsLimitDminFVStart = 0.5;

params.vtParamsLimitDmaxCVEnd = 0.4;
params.vtParamsLimitDminCVEnd = 0.3;

% type identifiers for targets
params.targetID_C = 1;
params.targetID_V = 2;
params.targetID_N = 3;
params.targetID_F = 4;

% put limit on articulator starting times
% was 0.6
params.vtParamsLimitSmax = 0.3;
params.vtParamsLimitSmin = 0.0;

% for PP
params.ppParamsMinVal=0;
params.ppParamsMaxVal=1;

% for sensory consequences
params.scParamsMinVal=0;
params.scParamsMaxVal=1;

% for csa
params.csaParamsMinVal=0;
params.csaParamsMaxVal=100;% chech this - what should it be?


% dimensionalities
params.vtParamsDim = 10; % vtParams vector length
params.ppParamsDim = 17; % ppParams vector length
params.scParamsDim = 20; % scParams vector length
params.csaParamsDim = 17;% csaParams vector length

% penalize for movements
params.weight.articulatorEffort = [1 0.2 0.2 0.2 0.2 0.2 0.2 0 0 0];

% external salience
params.weight.external_sumSTPower = 0.05;
params.weight.external_sumSpectrogramNDiffF = 0.1;

% get silence targets
% OLD
% vtpars = [(-1.5/-3)  (2.0/3)  (0.0/-3)  (-0.5/-3) (-0.5)   (-0.5/-3) (0)  (-1) (0) (0)];
% vtpars = GetVowelV2('O', 0, 0);
% vtpars = GetVowelV2('Aa', -1, 0);
% schwa without voicing
vtpars = GetVowelV2('E', -0.6, 0);

% default in not learned
% also for silence padding
params.segmentDuration = 0.4;
params.segmentDurationOneTarget = 1.0;

% define silence target for VT
params.SilBoy = vtpars;
params.SilBoyDur = 0.2;

% define silence target for VT
params.SilBoyTPSD = vtpars;
params.SilBoyDurTPSD = ones(1,10)* params.SilBoyDur;
params.SilBoyStartTPSD = zeros(1,10);

adult=0;
if(adult)
    % adult lung capacities
    params.tidalVolumeCapacity = 6;
    params.vitalCapacity = 5;
    params.normalUpperExpiritoryLevel=4;
    params.restingExpiritoryLevel = 3;
    params.residualCapacity = 1;
    
    % adult
    params.lungSpringConstant=2;
   
    % useage per syllable 
    % 5% of TVC
    params.volumePerSyllable = 5/100 * params.tidalVolumeCapacity;
else
    % baby lung capacities
    % has 25% of adult
    params.tidalVolumeCapacity = 6/4;
    params.vitalCapacity = 5/4;
    params.normalUpperExpiritoryLevel=4/4;
    params.restingExpiritoryLevel = 3/4;
    params.residualCapacity = 1/4;

    % baby has close to zero
    params.lungSpringConstant=0.0;
    
    % useage per syllable 
    params.volumePerSyllable = 16/100 * params.tidalVolumeCapacity;        
end

% breathing flow range
params.flowRange = (params.normalUpperExpiritoryLevel -  params.restingExpiritoryLevel);

% syllables per breath
params.syllablesPerBreath = params.flowRange/params.volumePerSyllable;


% mean syllable duration
sum = params.vtParamsLimitDmax;
sum = sum + params.vtParamsLimitDmin;
sum = sum/2;   
meanSyllableDuration = sum;

% want it to run out of breath after params.syllablesPerBreath
% scale so runs of of breath at necessary  force 
% after  timeOutOfBreath in seconds
params.necessaryLungForce = 0.1;
timeOutOfBreath = params.syllablesPerBreath * meanSyllableDuration;
params.airFlowForceScale = params.flowRange/(timeOutOfBreath  * params.framerate * params.necessaryLungForce );
