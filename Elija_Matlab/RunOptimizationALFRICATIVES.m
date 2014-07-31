function RunOptimizationALFRICATIVES(params, filename, targetsDir)
% run optimization on motor pattern with 2 targets for FRICATIVES
% includes active learning

% make root output directory
mkdir(sprintf('%s', targetsDir));

% add directory
fullFilename = sprintf('%s\\%s', targetsDir, filename);

% check filename exists
appendDataStructure=0;
filenameMAT = sprintf('%s.mat',fullFilename);
fid = fopen(filenameMAT);
if(fid > -1)
    % file exists so close it again
    fclose(fid)
    % load file
    load(fullFilename);
    appendDataStructure=1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(~appendDataStructure)    
    disp('Starting new exeriment');

    % init motor memory
    [AllData.motorTargetMemory, params] = InitMotorTargetMemory(params);
    [AllData.motorTargetMemoryInit, params]  = InitMotorTargetMemory(params);
else
    disp('Appending existing exeriment');    
end

% get stating point
startingTrial = AllData.motorTargetMemory.currentIdx;
if(startingTrial > params.memoryEntries)
    disp('Finished');
    return;
end

% if experiment not already started...

% initialize clustering
% init diversity manager
params.motorList = DM_InitMotorPatternList(params.vtParamsDim,-params.vtParamsLimit, params.vtParamsLimit,...
                                            params.ppParamsDim, params.ppParamsMinVal, params.ppParamsMaxVal,...
                                            params.scParamsDim, params.scParamsMinVal, params.scParamsMaxVal,...
                                            params.csaParamsDim, params.csaParamsMinVal, params.csaParamsMaxVal);

% if experiment already started...
if(startingTrial>1)
    
    % add current entries that have already been found
    for sidx = 1:(startingTrial-1)

        % get target
        aparam_old = AllData.motorTargetMemory.target(sidx,:);
        
        % get proprioception
        pp_old = AllData.motorTargetMemory.ppParams(sidx,:);
        
        % get sensory consequences
        sc_old = AllData.motorTargetMemory.scParams(sidx,:);
    
        % get csa consequences
        csa_old = AllData.motorTargetMemory.csaParams(sidx,:);
        
        % add new pattern to list
        params.motorList = DM_AddMotorPatternToList(params.motorList, aparam_old, pp_old, sc_old, csa_old);    
    end
end

% loop over entries
replacedCnt=0;
done =0;
trials = startingTrial
attemptCnt=0;
while(done ==0)    
    
    % record the number of attenpts
    attemptCnt = attemptCnt+1;
    params.currentTrial = trials;

    disp(sprintf('Motor pattern: attempt %g of %g/%g',attemptCnt, trials, params.memoryEntries));     

    % i without contact
    initDone=0;
    while(initDone==0)
        
        % have a random starting point
        [aparam_init, lb, ub] = GenerateRandomTarget(params);            
    
        % run objective function again to get sensory consequences
        [cost, sensoryConsequences] = objfunFull2TALCore(aparam_init, params.libname, params);
    
        % scalarEvaluation is evaluated value of the gesture
        [salience, sumSpectrogramNDiffF, sumHPFSTContact, sumLPFPower, sumLFversusHFratio, sumHFversusLFratio] = GetSensoryConsequencesEvaluation(params, sensoryConsequences);       
        
        % get maximum number of contacts
        contactCount = sum(sensoryConsequences.ppParams);
    
        % if contacts then fail
        if( contactCount < 1)
            initDone=1;
        end
    end    
            
    % do a constrained optimization
    options = optimset('LargeScale','off', 'MaxIter', params.optimizationCycles, 'Display','iter','MaxFunEvals',params.functionCalls );
               
    if(params.optimizationCycles == 0)
        aparam_found=aparam_init;
        fval=0;
    else
        % run optimization
         % no constraints
         A=[];
         b=[];
         Aeq=[];
         beq=[];          
         [aparam_found, fval, exitflag, output] = fmincon(@objfunFull2TALCore, aparam_init, A, b, Aeq, beq, lb,ub, @nonlcon, options, params.libname, params)
    end
    
    % run objective function again to get sensory consequences
	[cost, sensoryConsequences] = objfunFull2TALCore(aparam_found, params.libname, params);
    
    % scalarEvaluation is evaluated value of the gesture
    [salience, sumSpectrogramNDiffF, sumHPFSTContact, sumLPFPower, sumLFversusHFratio, sumHFversusLFratio] = GetSensoryConsequencesEvaluation(params, sensoryConsequences);       
    
    % get maximum number of contacts
    contactCount = sum(sensoryConsequences.ppParams);

    % if more LF than HF power
    % if contacts then fail
    % OR if too sensitive reject
    %if( (abs(sumLFversusHFratio) > abs(sumHFversusLFratio)) && ...
    if(  (contactCount < 1)  )
    
        % add new pattern to list
        pp_found = sensoryConsequences.ppParams;
        sc_found = sensoryConsequences.scParams;
        csa_found =  mean(sensoryConsequences.TubeCSA,2)';
        params.motorList = DM_AddMotorPatternToList(params.motorList, aparam_found, pp_found, sc_found, csa_found);
        
        % record target
        % changes sign of fval so that +ve values are good
        AllData.motorTargetMemory  = DM_EnterMotorTarget(AllData.motorTargetMemory, aparam_found, pp_found, sc_found, csa_found, -fval);  
    
        % save data files each loop
        save(fullFilename, 'AllData');        

        % next trial
        trials = trials+1;
        if(trials > params.memoryEntries)
                done = 1;
        end
    else        
        if(contactCount >= 1 )
            disp(sprintf('Abandoned because: Contact = %g',contactCount));
        end
     end
    
    % abandon after 100x attemps
    if(attemptCnt > params.memoryEntries * 100)
        done =1;
    end            
end



