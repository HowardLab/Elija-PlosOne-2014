function [trajectoryCD, trajectory, trajectoryBeta]  = GenerateTrajectoryV2(params, beta, betaScale, targets1D, onsetTimes1D, durationTimes1D, padLength)
% generate trajectory given
% targets
% onset times
% durations

% chreck valid operation
if(params.interpolationMode ~= params.interpolationCriticalDamping)
    disp('GenerateTrajectoryV2:: Only defined for interpolationCriticalDamping');
    return;
end

% init
trajectory = [];
betaScaleIdx= [];

if(0)
% test
samplingRate=100;
targets1D         = [5,8,-6,1];
onsetTimes1D      = [0.2,0.0,0.3,0.1];
durationTimes1D   = [0.1,0.15,1.0,0.5];
end

% check data consistent
testLen(1) = length(targets1D);
testLen(2) = length(onsetTimes1D);
testLen(3) = length(durationTimes1D);
if( max(testLen) ~= min(testLen) )
    disp('GenerateTrajectoryV2: error, lengths incompatible');
    return
end

% all targets are 1-d
onsetSamples = onsetTimes1D * params.framerate;
durationSamples = durationTimes1D * params.framerate;
targetCnt = length(targets1D);

% for all targets
tidx=1;
lastTarget=targets1D(tidx);
outIdx=1;
lastTidx=tidx;
for tidx = 2:targetCnt
    
    for sidx = 1:onsetSamples(tidx)
        trajectoryBeta(outIdx) = beta * betaScale(lastTidx);
        trajectory(outIdx) =  lastTarget;
        betaScaleIdx(outIdx) = lastTidx;
        outIdx = outIdx + 1;
    end
    
    % get current target
    currentTarget = targets1D(tidx);

    for sidx = 1:durationSamples(tidx)
        trajectoryBeta(outIdx) = beta * betaScale(tidx);
        trajectory(outIdx) =  currentTarget;
        betaScaleIdx(outIdx) = tidx;
        outIdx = outIdx +1;
    end
    
    % update target
    lastTarget = currentTarget;
    lastTidx=tidx;
end

% pad out remainder
traLen=length(trajectory);
if(padLength > traLen)    
    trajectory(traLen:padLength) = trajectory(traLen);
end    

% interpolate between targets levels with critically damped 2nd order system
wantDebugTraces=0;
trajectoryCD = CriticalDampTransitions(trajectory, beta, betaScale, betaScaleIdx, params.samplerate, wantDebugTraces);



