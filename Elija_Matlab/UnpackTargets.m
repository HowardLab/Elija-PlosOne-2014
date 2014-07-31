function motorTargetMemoryOut = UnpackTargets(params, motorTargetMemoryIn);    
% unpack the targets for gesture into linear list

motorTargetMemoryOut = [];
oidx = 1;  
targetCounts=2;


% for all trials
entries = size(motorTargetMemoryIn.target,1);
for ridx = 1:entries

    % read target value
    vtParams = motorTargetMemoryIn.target(ridx,:);
    
    % decode mode    
    switch (params.vtParamsMode)
              
        case params.vtParamsOneTarget
            % unpack & expand infant to full data set
            % direct copy starting position
            vtparsStart = vtParams(1:10);  

            %  copy again for ending position
            vtparsEnd = vtParams(1:10);       
                
            % now full width
            motorTargetMemoryOut.vectorWidth=10;   
            % sample time from gaussian distribution
            duration = abs(params.segmentDurationOneTarget + randn * params.segmentDurationOneTarget/10);
            motorTargetMemoryOut.fullDurationStartTimes = 0;
        
            
       case params.vtParamsOneTargetFixDur
            % unpack & expand infant to full data set
            
            % same Fx value across all utterances
            vtParams(9) = 0; 
             
            % direct copy starting position
            vtparsStart = vtParams(1:10);  

            %  copy again for ending position
            vtparsEnd = vtParams(1:10);       
                
            % now full width
            motorTargetMemoryOut.vectorWidth=10;   
            
            % deterministic duration
            duration = params.segmentDurationOneTarget;

            motorTargetMemoryOut.fullDurationStartTimes = 0;
            
            %disp('same Fx value across all utterances; deterministic duration');
            
        case params.vtParamsInfant
            % unpack & expand infant to full data set
            % direct copy starting position
            vtparsStart = vtParams(1:10);  

            % first copy again for ending position
            vtparsEnd = vtParams(1:10);       
            % now put in second target parameters
            % jaw
            vtparsEnd(1) = vtParams(11);            
            % tongue same as start (2,3,4)
            % lips
            vtparsEnd(5) = vtParams(12);
            % lip prortusion same as start (6)
            % layrynx height same as start (7)
            % voicing, Fx
            vtparsEnd(8) = vtParams(13);            
            vtparsEnd(9) = vtParams(14);   
            % nasality
            vtparsEnd(10) = vtParams(15);            
                
            % now full width
            motorTargetMemoryOut.vectorWidth=10;   
            % sample time from gaussian distribution
            duration = abs(params.segmentDuration + randn * params.segmentDuration/10);
            
            % clip duration
            if( duration > params.vtParamsLimitDmax) 
               duration = params.vtParamsLimitDmax;
            end
            if( duration < params.vtParamsLimitDmin) 
              duration = params.vtParamsLimitDmin;
            end
            
            motorTargetMemoryOut.fullDurationStartTimes = 0;

        case params.vtParamsBoy
            % unpack 
            vtparsStart = vtParams(1:10);
            vtparsEnd = vtParams(11:20);
            motorTargetMemoryOut.vectorWidth=10;  
            
            % sample time from gaussian distribution
            duration = abs(params.segmentDuration + randn * params.segmentDuration/10);
            motorTargetMemoryOut.fullDurationStartTimes = 0;

            % clip duration
            if( duration > params.vtParamsLimitDmax) 
               duration = params.vtParamsLimitDmax;
            end
            if( duration < params.vtParamsLimitDmin) 
              duration = params.vtParamsLimitDmin;
            end
            
        case params.vtParamsInfantTP1
                                         
            % unpack & expand infant to full data set
            % direct copy starting position
            vtparsStart = vtParams(1:10);  

            % first copy again for ending position
            vtparsEnd = vtParams(1:10);       
            % now put in second target parameters
            % jaw
            vtparsEnd(1) = vtParams(11);            
            % tongue same as start (2,3,4)
            % lips
            vtparsEnd(5) = vtParams(12);
            % lip prortusion same as start (6)
            % layrynx height same as start (7)
            % voicing, Fx
            vtparsEnd(8) = vtParams(13);            
            vtparsEnd(9) = vtParams(14);   
            % nasality
            vtparsEnd(10) = vtParams(15);            

            % extract temporal components
            duration = vtParams(16);

            % clip duration
            if( duration > params.vtParamsLimitDmax) 
               duration = params.vtParamsLimitDmax;
            end
            if( duration < params.vtParamsLimitDmin) 
              duration = params.vtParamsLimitDmin;
            end
            
            % now full width
            motorTargetMemoryOut.vectorWidth=15;    
            motorTargetMemoryOut.fullDurationStartTimes = 0;
            
        case params.vtParamsBoyTP1
            
            % unpack & expand infant to full data set
            vtparsStart = vtParams(1:10);
            vtparsEnd = vtParams(11:20);

            % extract temporal components
            duration = vtParams(21);
            
            % clip duration
            if( duration > params.vtParamsLimitDmax) 
               duration = params.vtParamsLimitDmax;
            end
            if( duration < params.vtParamsLimitDmin) 
              duration = params.vtParamsLimitDmin;
            end
            
            % now full width
            motorTargetMemoryOut.vectorWidth=21;    
            motorTargetMemoryOut.fullDurationStartTimes = 0;
            
        case params.vtParamsCrandV
             patternVectorLen = motorTargetMemoryIn.targetsWidth(ridx,:);

            if(patternVectorLen == 31)
                
                % have 3 targets in pattern 
                targetCounts=3;
                
                % unpack
                vtparsStart = vtParams(1:10);
                vtparsEnd = vtParams(11:20);                
                vtparsEnd2 = vtParams(21:30);                
            
                % extract temporal components
                duration = vtParams(31);
                
                % clip vtparams to limits
                fidx = find(vtparsEnd2 > params.vtParamsLimit);
                vtparsEnd2(fidx) = params.vtParamsLimit;
                fidx = find(vtparsEnd2 < -params.vtParamsLimit);
                vtparsEnd2(fidx) = -params.vtParamsLimit;
                
            else
                % unpack
                vtparsStart = vtParams(1:10);
                vtparsEnd = vtParams(11:20);                

                % extract temporal components
                duration = vtParams(21);
            end
            
            % clip duration
            if( duration > params.vtParamsLimitDmaxCV) 
               duration = params.vtParamsLimitDmaxCV;
            end
            if( duration < params.vtParamsLimitDminCV) 
              duration = params.vtParamsLimitDminCV;
            end
                       
            % now full width
            motorTargetMemoryOut.vectorWidth=21;    
            motorTargetMemoryOut.fullDurationStartTimes = 0;
            
            
             
        case params.vtParamsVCrand            
            % unpack & expand infant to full data set
            vtparsStart = vtParams(1:10);
            vtparsEnd = vtParams(11:20);

            % extract temporal components
            duration = vtParams(21);
            
            % clip duration
            if( duration > params.vtParamsLimitDmaxCV) 
               duration = params.vtParamsLimitDmaxCV;
            end
            if( duration < params.vtParamsLimitDminCV) 
              duration = params.vtParamsLimitDminCV;
            end
            
            % now full width
            motorTargetMemoryOut.vectorWidth=21;    
            motorTargetMemoryOut.fullDurationStartTimes = 0;
            
        case {params.vtParamsInfantTPSD, params.vtParamsInfantTPSD_BREATH}
            % unpack & expand infant to full data set
            % direct copy starting position
            vtparsStart = vtParams(1:10);  

            % first copy again for ending position
            vtparsEnd = vtParams(1:10);       
            % now put in second target parameters
            % jaw
            vtparsEnd(1) = vtParams(11);            
            % tongue same as start (2,3,4)
            % lips
            vtparsEnd(5) = vtParams(12);
            % lip prortusion same as start (6)
            % layrynx height same as start (7)
            % voicing, Fx
            vtparsEnd(8) = vtParams(13);            
            vtparsEnd(9) = vtParams(14);   
            % nasality
            vtparsEnd(10) = vtParams(15);            

            % extract temporal components
            durationTime = vtParams(16:25);
            startTime = vtParams(26:35);
                        
            % now full width
            motorTargetMemoryOut.vectorWidth=35;    
            motorTargetMemoryOut.fullDurationStartTimes = 1;
            
        case {params.vtParamsBoyTPSD, params.vtParamsBoyTPSD_BREATH}
            % unpack & expand infant to full data set
            vtparsStart = vtParams(1:10);
            vtparsEnd = vtParams(11:20);

            % extract temporal components
            durationTime = vtParams(21:30);
            startTime = vtParams(31:40);
            
            % now full width
            motorTargetMemoryOut.vectorWidth=40;    
            motorTargetMemoryOut.fullDurationStartTimes = 1;
            
        otherwise
            disp('UnpackTargets::vtParamsMode Undefined');
            return;
    end

    % clip vtparams to limits
    fidx = find(vtparsStart > params.vtParamsLimit);
    vtparsStart(fidx) = params.vtParamsLimit;
    fidx = find(vtparsStart < -params.vtParamsLimit);
    vtparsStart(fidx) = -params.vtParamsLimit;
    
    % clip vtparams to limits
    fidx = find(vtparsEnd > params.vtParamsLimit);
    vtparsEnd(fidx) = params.vtParamsLimit;
    fidx = find(vtparsEnd < -params.vtParamsLimit);
    vtparsEnd(fidx) = -params.vtParamsLimit;
                         
    % if full times
    if(motorTargetMemoryOut.fullDurationStartTimes)

        % clip duration
        fidx = find(durationTime > params.vtParamsLimitDmax);
        durationTime(fidx) = params.vtParamsLimitDmax;
        fidx = find(durationTime < params.vtParamsLimitDmin);
        durationTime(fidx) = params.vtParamsLimitDmin;        
        motorTargetMemoryOut.durationTime(oidx,:) = durationTime;
        
        % clip start time
        fidx = find(startTime > params.vtParamsLimitSmax);
        durationTime(fidx) = params.vtParamsLimitSmax;
        fidx = find(startTime < params.vtParamsLimitSmin);
        durationTime(fidx) = params.vtParamsLimitSmin;        
        motorTargetMemoryOut.startTime(oidx,:) = startTime;        
        motorTargetMemoryOut.startTime(oidx,:) = startTime;    
    else
        motorTargetMemoryOut.duration(oidx) = duration;
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    motorTargetMemoryOut.target(oidx,:) = vtparsStart;
    if(isfield(motorTargetMemoryIn,'internalReward'))   
        motorTargetMemoryOut.internalReward(oidx,:) = motorTargetMemoryIn.internalReward(ridx); 
    end
    
    if(isfield(motorTargetMemoryIn,'reinforcementValue'))   
        motorTargetMemoryOut.reinforcementValue(oidx, :) = motorTargetMemoryIn.reinforcementValue(ridx);
    end
    oidx = oidx+1;  
        
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    motorTargetMemoryOut.target(oidx,:) = vtparsEnd;
    if(isfield(motorTargetMemoryIn,'internalReward'))   
        motorTargetMemoryOut.internalReward(oidx,:) = motorTargetMemoryIn.internalReward(ridx);
    end
    if(isfield(motorTargetMemoryIn,'reinforcementValue'))   
        motorTargetMemoryOut.reinforcementValue(oidx, :) = motorTargetMemoryIn.reinforcementValue(ridx);
    end

    % if full times
    if(motorTargetMemoryOut.fullDurationStartTimes)
        motorTargetMemoryOut.durationTime(oidx,:) = durationTime;
        motorTargetMemoryOut.startTime(oidx,:) = startTime;    
    else
        motorTargetMemoryOut.duration(oidx) = duration;
    end

    oidx = oidx+1;    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % check for 3 target patterns
    if(targetCounts==3)
    
         motorTargetMemoryOut.target(oidx,:) = vtparsEnd2;
        if(isfield(motorTargetMemoryIn,'internalReward'))   
            motorTargetMemoryOut.internalReward(oidx,:) = motorTargetMemoryIn.internalReward(ridx);
        end
        if(isfield(motorTargetMemoryIn,'reinforcementValue'))   
            motorTargetMemoryOut.reinforcementValue(oidx, :) = motorTargetMemoryIn.reinforcementValue(ridx);
        end
        
        % if full times
        if(motorTargetMemoryOut.fullDurationStartTimes)
            motorTargetMemoryOut.durationTime(oidx,:) = durationTime;
            motorTargetMemoryOut.startTime(oidx,:) = startTime;    
        else
            motorTargetMemoryOut.duration(oidx) = duration;
        end
    
        oidx = oidx+1;
        
    end    
end

if(isfield(motorTargetMemoryIn,'currentIdx'))   
    motorTargetMemoryOut.currentIdx = motorTargetMemoryIn.currentIdx * 2 - 1;
end

if(isfield(motorTargetMemoryIn,'limit'))   
    motorTargetMemoryOut.limit = motorTargetMemoryIn.limit;
end

