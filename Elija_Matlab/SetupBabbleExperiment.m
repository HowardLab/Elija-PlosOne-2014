function [model, params, setup, success] =  SetupBabbleExperiment(datasetName, experimentName, entries, ask)
% setup babbling experiment

success=0;
wantTestMode=0;
fileName = sprintf('AGENTSETUP_%s_%s', datasetName, experimentName);
[setup, loaded]  = LoadAgentSetup(fileName);
if(loaded==false || ask)
    % run setup in test mode
    setup = RunInfantAgentSetup(experimentName, datasetName, wantTestMode, ask);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
model = InitDefsV2;
params=[];
% only for mac version
%params = ConfigureVTSYNTHMacV1(params);
params = ConfigureVTSYNTHV3(params);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
params.memoryEntries = entries; 
params.optimizationCycles = 8;
params.functionCalls = 100;
params.filename = fileName;
success=1;
params.betaScale = 1;


