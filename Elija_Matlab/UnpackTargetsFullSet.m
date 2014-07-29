function linearTargets = UnpackTargetsFullSet(params, motorTargetMemoryIn);    
% unpack the targets for gesture into linear list
% full parameter set format
% with durations, betas, types
% and with start and duration time parameter for each articulator
% supports:     params.vtParamsFullSet
% supports:     params.vtParamsFullSetFixDur   - with fixed durations to minimize variability

linearTargets = [];
oidx = 1;  
targetCounts=2;

% decode mode    
switch (params.vtParamsMode)                 
	case {params.vtParamsFullSet, params.vtParamsFullSetFixDur}
	% thats OK  
    otherwise
	disp('UnpackTargetsFullSet::vtParamsMode Undefined');
    return
end
     


% for all entries
entries = size(motorTargetMemoryIn.target,1);
for ridx = 1:entries

    % read target value
    vtParams = motorTargetMemoryIn.target(ridx,:);
    patternVectorLen = motorTargetMemoryIn.targetsWidth(ridx,:);

    % decode mode    
    switch (patternVectorLen)
                         
        case {138}
                              
            % unpack & expand infant to full data set
            linearTargets.target(oidx,:) = vtParams(1:10);               
            linearTargets.target(oidx+1,:) = vtParams(11:20);
            linearTargets.target(oidx+2,:) = vtParams(21:30);
            linearTargets.target(oidx+3,:) = vtParams(31:40);
                        
            % start times
            linearTargets.startTime(oidx,:) = vtParams(51:60);
            linearTargets.startTime(oidx+1,:) = vtParams(61:70);
            linearTargets.startTime(oidx+2,:) = vtParams(71:80);
            linearTargets.startTime(oidx+3,:) = vtParams(81:90);          
            
            %  durations
            linearTargets.durationTime(oidx,:) = vtParams(91:100);         
            linearTargets.durationTime(oidx+1,:) = vtParams(101:110);
            linearTargets.durationTime(oidx+2,:) = vtParams(111:120);     
            linearTargets.durationTime(oidx+3,:) = vtParams(121:130);
            
            % extract beta scale components
            linearTargets.betaScale(oidx) = vtParams(131);
            linearTargets.betaScale(oidx+1) = vtParams(132);
            linearTargets.betaScale(oidx+2) = vtParams(133);
            linearTargets.betaScale(oidx+3) = vtParams(134);

            % update                   
            oidx = oidx+4;  
            
        case {160}
                              
            % unpack & expand infant to full data set
            linearTargets.target(oidx,:) = vtParams(1:10);               
            linearTargets.target(oidx+1,:) = vtParams(11:20);
            linearTargets.target(oidx+2,:) = vtParams(21:30);
            linearTargets.target(oidx+3,:) = vtParams(31:40);
            linearTargets.target(oidx+4,:) = vtParams(41:50);
                        
            % start times
            linearTargets.startTime(oidx,:) = vtParams(51:60);
            linearTargets.startTime(oidx+1,:) = vtParams(61:70);
            linearTargets.startTime(oidx+2,:) = vtParams(71:80);
            linearTargets.startTime(oidx+3,:) = vtParams(81:90);          
            linearTargets.startTime(oidx+4,:) = vtParams(91:100);          
            
            %  durations
            linearTargets.durationTime(oidx,:) = vtParams(101:110);         
            linearTargets.durationTime(oidx+1,:) = vtParams(111:120);
            linearTargets.durationTime(oidx+2,:) = vtParams(121:130);     
            linearTargets.durationTime(oidx+3,:) = vtParams(131:140);
            linearTargets.durationTime(oidx+4,:) = vtParams(141:150);
            
            % extract beta scale components
            linearTargets.betaScale(oidx) = vtParams(151);
            linearTargets.betaScale(oidx+1) = vtParams(152);
            linearTargets.betaScale(oidx+2) = vtParams(153);
            linearTargets.betaScale(oidx+3) = vtParams(154);
            linearTargets.betaScale(oidx+4) = vtParams(155);
            
            % update                   
            oidx = oidx+5;  
            
        case {190}
                              
            % unpack & expand infant to full data set
            linearTargets.target(oidx,:) = vtParams(1:10);               
            linearTargets.target(oidx+1,:) = vtParams(11:20);
            linearTargets.target(oidx+2,:) = vtParams(21:30);
            linearTargets.target(oidx+3,:) = vtParams(31:40);
            linearTargets.target(oidx+4,:) = vtParams(41:50);
            linearTargets.target(oidx+5,:) = vtParams(51:60);
                        
            % start times
            linearTargets.startTime(oidx,:) = vtParams(61:70);
            linearTargets.startTime(oidx+1,:) = vtParams(71:80);
            linearTargets.startTime(oidx+2,:) = vtParams(81:90);
            linearTargets.startTime(oidx+3,:) = vtParams(91:100);          
            linearTargets.startTime(oidx+4,:) = vtParams(101:110);          
            linearTargets.startTime(oidx+5,:) = vtParams(111:120);          
            
            %  durations
            linearTargets.durationTime(oidx,:) = vtParams(121:130);         
            linearTargets.durationTime(oidx+1,:) = vtParams(131:140);
            linearTargets.durationTime(oidx+2,:) = vtParams(141:150);     
            linearTargets.durationTime(oidx+3,:) = vtParams(151:160);
            linearTargets.durationTime(oidx+4,:) = vtParams(161:170);
            linearTargets.durationTime(oidx+5,:) = vtParams(171:180);
                        
            % extract beta scale components
            linearTargets.betaScale(oidx) = vtParams(181);
            linearTargets.betaScale(oidx+1) = vtParams(182);
            linearTargets.betaScale(oidx+2) = vtParams(183);
            linearTargets.betaScale(oidx+3) = vtParams(184);
            linearTargets.betaScale(oidx+4) = vtParams(185);
            linearTargets.betaScale(oidx+5) = vtParams(186);
            
            % update                   
            oidx = oidx+6;  
                        
        otherwise
            disp('UnpackTargetsFullSet::patternVectorLen Undefined');
            return;
    end
end

if(isfield(motorTargetMemoryIn,'currentIdx'))   
    linearTargets.currentIdx = motorTargetMemoryIn.currentIdx * 2 - 1;
end

if(isfield(motorTargetMemoryIn,'limit'))   
    linearTargets.limit = motorTargetMemoryIn.limit;
end

