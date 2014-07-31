function [motorTargetMemory, params]  = InitMotorTargetMemory(params)
% init motor memory

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% computed parameters
switch params.vtParamsMode
    case params.vtParamsCrandV
        params.vtParamsVectorWidth = 21;            
    case params.vtParamsVCrand
        params.vtParamsVectorWidth = 21;            
    case params.vtParamsOneTarget
        params.vtParamsVectorWidth = 10;    
    case params.vtParamsOneTargetFixDur
        params.vtParamsVectorWidth = 10;    
    case params.vtParamsInfant
        params.vtParamsVectorWidth = 15;
    case params.vtParamsBoy
        params.vtParamsVectorWidth = 20;
    case params.vtParamsInfantTP1
        % 15 VTparams + segmentDuration 
        params.vtParamsVectorWidth = 16;
    case params.vtParamsBoyTP1
        % 20 VTparams + segmentDuration 
        params.vtParamsVectorWidth = 21;
    case {params.vtParamsInfantTPSD, params.vtParamsInfantTPSD_BREATH}
        % 15 VTparams + 10  durationTimes +  10 startTimes
        params.vtParamsVectorWidth = 35;
    case {params.vtParamsBoyTPSD, params.vtParamsBoyTPSD_BREATH}
        % 20 VTparams + 10  durationTimes +  10 startTimes
        params.vtParamsVectorWidth = 40;
    otherwise
        disp('InitMotorTargetMemory::params.vtParamsMode undefined');
        return;
end

params.memoryEntries

% as of yet no value assigned
motorTargetMemory = [];
motorTargetMemory.internalRewardCnt = zeros(params.memoryEntries,1);
motorTargetMemory.externalRewardCnt = zeros(params.memoryEntries,1);

motorTargetMemory.internalReward = [];
motorTargetMemory.externalReward = [];

motorTargetMemory.internalSalience = [];
motorTargetMemory.externalSalience = [];
motorTargetMemory.motorEffort = [];

motorTargetMemory.target = [];

motorTargetMemory.currentIdx = 1;    
motorTargetMemory.vectorWidth = params.vtParamsVectorWidth;    

