function [cost, sensoryConsequences] = objfunFull2TALCore(vtParams, libname, params)
% run optimization on motor pattern with 2 targets for VOWELS
% includes active learning
    csaParams=[];

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % want same processing function in all parts of system
    % get target from optimized parameter vector       
    % put parameters into common format    
    wantDebugTraces=0;
    motorTargetMemory.target(1,:) = vtParams;
    motorTargetMemory.value(1,:) = 0;
    motorTargetMemory.currentIdx = 1;
    
    % TEST ONLY, will delete
    %if( isfield(Data, 'targetsWidth') )
    %        motorTargetMemory.targetsWidth(ridx,:) = Data.targetsWidth(targetIndex,:);
   	%else
    %        motorTargetMemory.targetsWidth(ridx,:) = Data.vectorWidth;
    %end
  
    wantSaveVTP=0;
    outputFilename = ' ';
    [sensoryConsequences, motor, duration] = PlayAllMotorMemory(motorTargetMemory, params, wantDebugTraces, params.silencePadding, wantSaveVTP, outputFilename);           
    
    % get tube cross sectional area
    csaParams = mean(sensoryConsequences.TubeCSA,2)';
        
    % get minima
    [minCSA, minCSAIdx] = min(csaParams);
    
    % decide if sensory consequences make configutation interesting
    % record flag indicates if gesture worth recording
    % scalarEvaluation is evaluated value of the gesture
    salience = GetSensoryConsequencesEvaluation(params, sensoryConsequences);
       
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % get proximity of pattern to existing ones
    ppParams = sensoryConsequences.ppParams';    
    scParams = sensoryConsequences.scParams';        
    vtParams = motorTargetMemory.target(1,:);       
            
    % compare all patterns to new pattern
    [vtParamsMinDist, ppParamsMinDist, scParamsMinDist, csaParamsMinDist]  = DM_MotorPatternDistanceToList(params.motorList, -1, vtParams, ppParams, scParams, csaParams);
                
    % add new pattern to list
    params.motorList = DM_AddMotorPatternToList(params.motorList, vtParams, ppParams, scParams, csaParams);
        
    % find minimum acoustic distance
    % ie pick best match
    minAcoustic = min(scParamsMinDist);        
    distanceCostSC = minAcoustic * params.scDistanceCostScaling * params.scParamsDMW;
        
    % find minimum vt parameter distance
    % ie pick best match
    minVT = min(vtParamsMinDist);        
    distanceCostVT = minVT * params.vtDistanceCostScaling * params.vtParamsDMW;
                
    % find minimum proprioceptive distance
    % ie pick best match
    minProprioceptive = min(ppParamsMinDist);        
    distanceCostPP = minProprioceptive * params.ppDistanceCostScaling * params.ppParamsDMW;
      
    % find minimum cross sectional area (csa) distanc, ie pick best match
    minCSA = min(csaParamsMinDist);        
    distanceCostCSA = minCSA * params.csaDistanceCostScaling * params.csaParamsDMW;
    
    % sum components
    totalDistanceCost = (distanceCostSC + distanceCostVT + distanceCostPP + distanceCostCSA);
          
    % cost due to deviation from desired location
    distanceFromMinIdx = abs(minCSAIdx - params.WantTubeMinimumPoint) * params.scParamsMinIdx; 
        
      
    % return critical values
    sensoryConsequences.totalDistanceCost = totalDistanceCost;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % compute overall cost
        
	% scale by the distance Cost to the nearest other pattern
    % NB: multiplicative
	cost = -(salience * totalDistanceCost  - motor.motorEffort - distanceFromMinIdx) ; 
        
	disp(sprintf('objfunFull2TALCore trial=%g:  dist=%g  sali=%g   motEff=%g,  dur=%g,  cost=%g',...
            params.currentTrial, totalDistanceCost, salience, motor.motorEffort,duration,cost));
    
    
    
 