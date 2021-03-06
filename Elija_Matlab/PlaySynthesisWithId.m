function PlaySynthesisWithId(params, filename, targetsDir, selectionIdx, label)
% Play all raw synthesis

% make root output directory
mkdir(sprintf('%s', targetsDir));
silencePadding=1;
mode=1;
debug=0;
repeats=1;

% add directory
fullFilename = sprintf('%s\\%s', targetsDir, filename);

% load data files
load(fullFilename);


    
    
switch mode
    case 1
        disp('use normal motorTargetMemory,target');
        data = AllData.motorTargetMemory;
    case 2
        disp('use motorTargetMemoryInit.target');
        data = AllData.motorTargetMemoryInit
    otherwise
        disp('PlayRawIndividualSynthesis mode undefined');
        return;
end
        
% get entries in data list
entriesData = size(data.target,1);

% loop over all motor memories
entries = size(selectionIdx,2);


if(0)
    % save outputBuffer
    for idx = 1: entriesData
        fName =  sprintf('MP%d.txt', idx);
        fid = fopen(fName, 'wt');
        outputBuffer = data.target(idx,:)';
        fprintf(fid, '%g\n', outputBuffer);
        fclose(fid)
    end
end  

    
for sidx = 1:entries
    
    jidx =  selectionIdx(sidx);

    % check range
    if(jidx <= entriesData)
    
        disp(sprintf('Playing %g repeats of %g of %g',repeats, jidx, entries)); 
        
         % put in the parameters repeated several times in memory
         motorTargetMemory = [];
         for ridx = 1:repeats
            motorTargetMemory.target(ridx,:) = data.target(jidx,:);
            
            if( isfield(data, 'targetsWidth') )
                motorTargetMemory.targetsWidth(ridx,:) = data.targetsWidth(jidx,:);
            else
                motorTargetMemory.targetsWidth(ridx,:) = data.vectorWidth;
            end
            
            motorTargetMemory.internalReward(ridx,:) = data.internalReward(jidx,:);
         end
         
        motorTargetMemory.currentIdx = data.currentIdx;

        % update utility weighting
        params = SetUtilityWeighting(params, ones(1,params.utilityWeighingVectorLen));

        % do synthesis
        wantSaveVTP=debug;
        outputFilename = sprintf('%s\\%s_%g',targetsDir, filename, jidx);        
 
        % PlayAllMotorMemory(motorTargetMemory, params, wantDebugTraces, silencePadding, wantSaveVTP, outputFilename)
        [sensoryConsequences, motor, duration] = PlayAllMotorMemory(motorTargetMemory, params, debug, silencePadding, wantSaveVTP, outputFilename);   
          
        
        % TEST if want plots
        if(0)
            PlotAllSensoryConsequences(params, sensoryConsequences, motor, outputFilename);
        
            % want vocoder spectrogram
            auditoryFilterbank(sensoryConsequences.outputBuffer, params.samplerate);            
        end
         

        % get number of contacts simultanbeously at each sample
        contactWaveform = sum(sensoryConsequences.VectorContact,1);               
        
        % get maximum number of contacts
        contactCount=max(contactWaveform);
        
        % scalarEvaluation is evaluated value of the gesture
        salience = GetSensoryConsequencesEvaluation(params, sensoryConsequences);
        reward = -(salience - motor.motorEffort); 
       
         % normalize amplitude
        maxVal = 1e-3 + max(abs(sensoryConsequences.outputBuffer));
        sensoryConsequences.outputBuffer = sensoryConsequences.outputBuffer/maxVal;

        % make output dierctory
        mkdir(targetsDir);
        mkdir(sprintf('%sSHT', targetsDir));

        % save speech for all targets as wav files
        outputFilename = sprintf('%s//%s_%s_%d.wav',targetsDir, filename, AllData.dataIdlabel{jidx},jidx);        
        shortFilename = sprintf('%sSHT//Elija_%d.wav',targetsDir,jidx);        
        SaveAsWav(params, sensoryConsequences.outputBuffer, outputFilename);
        SaveAsWav(params, sensoryConsequences.outputBuffer, shortFilename);

        if(0)
        fName =  sprintf('%sSHT/Effort_%d.txt',targetsDir, jidx);
        fid = fopen(fName, 'wt');
        fprintf(fid, '%g\n', motor.motorEffort);
        fclose(fid)

        fName =  sprintf('%sSHT/Salience_%d.txt',targetsDir, jidx);
        fid = fopen(fName, 'wt');
        fprintf(fid, '%g\n', salience);
        fclose(fid)
        end
        
        
        disp(sprintf('Filename = %s',sidx,  outputFilename));
        disp(sprintf('Contact[%g] = %g',sidx,  contactCount));
        disp(sprintf('salience=%g  motorEffort=%g, reward=%g, duration=%g', salience, motor.motorEffort, reward, duration));
    
    end
end
