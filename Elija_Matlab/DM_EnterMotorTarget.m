function motorTargetMemory = DM_EnterMotorTarget(motorTargetMemory, vtpars, ppParams, scParams, csaParams, scalarEvaluation)
% enter motor target into list

% get current index
idx = motorTargetMemory.currentIdx;

% reward counter
motorTargetMemory.internalRewardCnt(idx) = motorTargetMemory.internalRewardCnt(idx) + 1;;

% load current evaluation
motorTargetMemory.internalReward(idx,:) = scalarEvaluation;
    
% and vt parameters
motorTargetMemory.target(idx,:) = vtpars;

% proprioceptive concequences
motorTargetMemory.ppParams(idx,:) = ppParams;

% sensory consequences
motorTargetMemory.scParams(idx,:) = scParams;

% csa consequences
motorTargetMemory.csaParams(idx,:) = csaParams;

% increment counter
motorTargetMemory.currentIdx =  idx + 1;
 

