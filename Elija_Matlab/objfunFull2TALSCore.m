function [cost, sensoryConsequences] = objfunFull2TALSCore(vtParams, libname, params)
% run optimization on motor pattern with 2 targets for VOWELS
% includes active learning and sensitivity analysis
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
      
    % find minimum cros sectional area (csa) distanc, ie pick best match
    minCSA = min(csaParamsMinDist);        
    distanceCostCSA = minCSA * params.csaDistanceCostScaling * params.csaParamsDMW;
    
    % sum components
    totalDistanceCost = (distanceCostSC + distanceCostVT + distanceCostPP + distanceCostCSA);
          
    % cost due to deviation from desired location
    distanceFromMinIdx = abs(minCSAIdx - params.WantTubeMinimumPoint) * params.scParamsMinIdx; 
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % do sensitivity analysis bt running many times with pertubations
    
    % perturb each of first 5 dimensions independently
    for didx = 1:6        
        % init the target
        testTarget = motorTargetMemory;
        
         % build test targets
        % range of parameters is -1 to +1
        % do a 5% pertubation
        pertubation=0.1;

        % didx=1: deviate Jaw position
        % didx=2: deviate Tongue dorsum position
        % didx=3: deviate Tongue dorsum shape
        % didx=4: deviate Tongue apex shape
        % didx=5: deviate Lip height (aperture)
        % NB: didx == 6 used for unperturbed case
        if(didx < 6)
            testTarget.target(didx) = testTarget.target(didx) + pertubation; 
        end
 
        % play perturbed target memory
        [sensoryConsequences, motor, duration] = PlayAllMotorMemory(testTarget, params, wantDebugTraces, params.silencePadding, wantSaveVTP, outputFilename);    
        
        % want analysis
        infantSTFT =  auditoryFilterbank(sensoryConsequences.outputBuffer, params.samplerate);            

        % mean filterbank output over central time section
        len = size(infantSTFT,2);
        startIdx = floor(len/3);        
        endIdx = floor(2 * len/3);        
        meanAuditory(didx,:) = mean(infantSTFT(:, startIdx:endIdx),2);
    end
    
    % compute differences between pertubed and normal configuration
    diff=[];
    for didx = 1:5
        diff(didx) = norm( squeeze(meanAuditory(didx,:)) -  squeeze(meanAuditory(6,:)) );
    end        
    motorPatternSensitivity = sqrt(sum(diff .^2 )) * params.sensitivityScaling; 
    
    % return critical values
    sensoryConsequences.motorPatternSensitivity = motorPatternSensitivity;
    sensoryConsequences.totalDistanceCost = totalDistanceCost;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % compute overall cost
        
	% scale by the distance Cost to the nearest other pattern
	cost = -(salience + totalDistanceCost - motorPatternSensitivity - motor.motorEffort - distanceFromMinIdx) ; 
        
	disp(sprintf('objfunFull2TALSCore trial=%g:  dist=%g  sali=%g  sens=%g   motEff=%g,  dur=%g,  cost=%g',...
            params.currentTrial, totalDistanceCost, salience, motorPatternSensitivity, motor.motorEffort,duration,cost));
    
    
    
 