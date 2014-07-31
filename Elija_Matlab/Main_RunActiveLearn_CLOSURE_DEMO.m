% Main_RunActiveLearnSen_CLOSURENASALOFF.m
% run actve learning to find vowels
% use sensitivity condition

close all
clear all 
clc

% want only 10 vowels which will the be optimized for
% diversity across vowel space
% and for low sensitivity   

% select 20 because no extra cost for more
patterns = 40;

ask=0;
selectionIdx = [1:patterns];
silencePadding=0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% To increase variety in sounds discovered by babbling, optimize over following reward criteria separately and then in combinations

% setup experiment
%  RUN reoptimizations
[model, params, setup] =  SetupBabbleExperiment('ALS_CLOSURE_NOFF4', 'TEST', patterns, ask);
params.wantNasalOn=0;
params.wantNasalOff=1;

params.wantVoiceOn=0;
params.wantVoiceOff=0;
params.wantVoiceScale=0;  
params.wantBreathFxModel=1;    
params.wantBreathingModel=0;

params.vtParamsMode = params.vtParamsOneTarget;
params.silencePadding=silencePadding;

% distance from min point
params.scParamsMinIdx = 0.0; % zero weight
params.WantTubeMinimumPoint=1;

params.functionCalls = 100;
params.wantClipGA=1;
params.scaleGA=1.0;
params.scaleFx=2;
params.wantNasalScale=0;

% set diversity weightings- only used acoustic sensory consequences for vowels
params.vtParamsDMW = 0; % only use vt 
params.ppParamsDMW = 1; % only use touch
params.scParamsDMW = 0; % only use sc 
params.csaParamsDMW =   0;
params.sensitivityScaling=1000;
params.scDistanceCostScaling=3000;
params.vtDistanceCostScaling=1000;
params.ppDistanceCostScaling=3000;
params.csaDistanceCostScaling=100;

params.motorPatternSensitivityThresh=300;

% 2 is quite strict
params.pruneContactTheshold=3;

% run optimization
utilityWeighing = 10 * ones(1,17); % encourage contact
utilityWeighing(18) = 0;    % power
utilityWeighing(19) = 0;   % dont want spectral change
utilityWeighing(20) = 0;    % voicing
utilityWeighing(21) = 1;    % minimize vocal effort
utilityWeighing(22) = 1;    % minimize articulator effort
utilityWeighing(23) = 0;    % nasal 
utilityWeighing(24) = 0;    % LFversusHF 
utilityWeighing(25) = 0;    % HFversusLF 
utilityWeighing(26) = 0;    % multiple tongue touch
utilityWeighing(27) = 0;    % tube minimimum location

% fix segment durations to minimize variability
params.vtParamsMode=params.vtParamsOneTargetFixDur;

% turn off breath model so no change in output over duration over utterance 
params.wantBreathFxModel=0;    
params.wantBreathingModel=0;

% set utility weightings
params = SetUtilityWeighting(params, utilityWeighing);  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% initialization and first 3 trials
    
params.optimizationCycles = 3;    
% run optimization to discover potentially useful VT configurations
% diversity only used wrt to previously discovered patterns
RunOptimizationALCLOSURE(params, setup.filenameOneTarget, setup.dirMotorTargets);
   
selectionIdx=3;
DisplayInfo(params, setup.filenameOneTarget, setup.dirMotorTargets, selectionIdx);

  
       