function [ElijaSpeech, CaregiverSpeech] = PlayAndReformulate(params, filename, targetsDir, dirOut, silencePadding, replayTheshold, wantTestMode)
% Play all raw synthesis on a cluster basis
% record responses
wantEnter=0;

% set weighinging for acoustic power
utilityWeighing = zeros(1,params.utilityWeighingVectorLen); 
utilityWeighing(18) = 1;    % power
firstTime = 1;

% setup beep
[beepSound, beepSoundFs, beepSoundnbits] = wavread('beep-29.wav');

% add directory
fullFilename = sprintf('%s\\%s', targetsDir, filename);

% make output directory
mkdir(dirOut);

% init
currentRunCount = 1;
runCount = 1;

% setup and specify boredom count
PAR_Data = PAR_SetupExperiment(fullFilename, params.boredomCount, params.WantReInit);

if(wantTestMode)
    maxRunCount=5;
    close all
    clc
    disp(sprintf('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++'));
    disp(' ');
    disp(sprintf('                   Talking with Elija'));
    disp(' ');
    disp('When you press "Enter", Elija will make a sound. Please respond');
    disp('as you would to a real infant, by either saying something or');
    disp('remaining silent.');
    disp(' ');
    disp('After a short pause, recording will finish and you will hear a'); 
    disp('soft beep. Elija is then ready for another interaction; press');
    disp('"Enter" again.');
    disp(' ');
    disp('Now press "Enter" when you are ready to begin a short practice');
    disp('session. In this, you will hear your first response replayed'); 
    disp('to you to confirm that the computer is working correctly.');
else
    maxRunCount=1000000;    
    close all
    clc
    disp(sprintf('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++'));
    disp(' ');
    disp(sprintf('                   Talking with Elija'));
    disp(' ');
    disp('When you press "Enter", Elija will make a sound. Please respond');
    disp('as you would to a real infant, by either saying something or');
    disp('remaining silent.');
    disp(' ');
    disp('After a short pause, recording will finish and you will hear a'); 
    disp('soft beep. Elija is then ready for another interaction; press');
    disp('"Enter" again.');
    disp(' ');
    disp(sprintf('After every %d interactions, we will ask you to take a short break.', params.haveABreak));
    disp(' ');
    disp('You may find it helpful to close your eyes while interacting');
    disp('with Elija.');
    disp(' ');
    disp('Now press "Enter" when you are ready to begin.');
    disp('(You will hear your first response replayed to you to confirm '); 
    disp('that the computer is working correctly.)');
end    

% loop until reformulations finished
while(PAR_Status(PAR_Data) &&  runCount < maxRunCount )
           
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if(wantEnter)
            inputFromKeyboard = input(sprintf('Press "Enter", listen to Elija and respond if this feels natural.'),'s');
        end
        
        % look for dont repeat condition
        runCountInc=0;
        if( firstTime == 1)
             firstTime = 0;
            %disp('PAR_GetNextPattern')
        end
        % get next motor target memory
        [PAR_Data, motorTargetMemory, jidx, erc] = PAR_GetNextPattern(PAR_Data);  
   
        %tic
        
        % disp(sprintf('Playing %g of %g      runCount=%d', jidx, PAR_Data.entriesData, runCount));                     
        disp(' ');
        disp(sprintf('Utterance %d', runCount));                     

        % update utility weighting
        params = SetUtilityWeighting(params, utilityWeighing);

        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % do synthesis
        wantSaveVTP=0;
        outputFilename = ' ';
        [sensoryConsequences, motor] = PlayAllMotorMemory(motorTargetMemory, params, 0, silencePadding, wantSaveVTP, outputFilename);   
                
        % scalarEvaluation is evaluated value of the gesture
        salience = GetSensoryConsequencesEvaluation(params, sensoryConsequences);
        reward = -(salience - motor.motorEffort); 
                
        % normalize amplitude
        maxVal = 1e-3 + max(abs(sensoryConsequences.outputBuffer));
        % reduce amplitude
        %maxVal=2;
        sensoryConsequences.outputBuffer = sensoryConsequences.outputBuffer/maxVal;
        
        % replay sound
        P=audioplayer(sensoryConsequences.outputBuffer, params.samplerate);
        play(P);
        % need to compute length and use is to set recording duration
        LIS = size(sensoryConsequences.outputBuffer,2)/params.samplerate;

        % use wider recording time, at least "2" seconds
        % so subjects hace time to make utterance
        lenInSecs =  max([LIS 4]);        
        
        % record at params.samplerate, params.bits bit
        params.bits = 16;
        recorder  = audiorecorder(params.samplerate, params.bits, 1);
        recordblocking(recorder, lenInSecs);
        ISD = getaudiodata(recorder , 'double');     
                
        
        % now cutout speech from inout slot using SoundDetector
        % this finds 1 clean segment with same start and end silence on all
        % utterances
        debug=0;
        mimicSpeech = SoundDetector(ISD, params.samplerate, params.framerate, debug);   
        
        % get salience measure of input speech
        externalSalience = AnalyseExtSpeechSalience(params, mimicSpeech', 0);   
        totalReward = -(salience + externalSalience- motor.motorEffort); 
        
        % normalize amplitude
        maxVal = 1e-3 + max(abs(mimicSpeech));
        % reduce amplitude
        %maxVal=2;
        mimicSpeech = mimicSpeech/maxVal;
            
        % only replay reformulation if externalSalience was more than replayTheshold
        % and only save speech if that was the caew
        if(externalSalience > replayTheshold)
                    
            %disp('INFANT REINFORCED - INFANT REINFORCED _ INFANT REINFORCED - INFANT REINFORCED');
            
            % save speech for all targets as wav files
            % only save first instance
            if(erc==0)
                outputFilename = sprintf('%s/Infant_%s_%g.wav', dirOut, filename,jidx);
                SaveAsWav(params, sensoryConsequences.outputBuffer, outputFilename);
                %disp(sprintf('RAWO: salience=%g  motorEffort=%g, reward=%g', salience, motor.motorEffort,reward));
            
                % record Elija's output speech
                ElijaSpeech{jidx} = sensoryConsequences.outputBuffer;        
            end
            
            % save speech for all targets as wav files
            outputFilename = sprintf('%s/Caregiver_%s_%g_%g.wav', dirOut, filename, jidx, erc+1);       
            SaveAsWav(params, mimicSpeech, outputFilename);
            
            % disp(sprintf('externalSalience=%g  motorEffort=%g, totalReward=%g', externalSalience, motor.motorEffort,totalReward));

            % record caregiver's reformulation
            CaregiverSpeech{jidx} = mimicSpeech;
            
            % only initially replay sound
            if(currentRunCount <= params.playGoodResponseCount)
                P=audioplayer(mimicSpeech, params.samplerate);
                play(P);
            end
            
            % increment
            currentRunCount = currentRunCount+1;
        end
                
        
        % update current pattern with results
        PAR_Data = PAR_UpdatePattern(PAR_Data, motor.motorEffort, salience, externalSalience, totalReward);  

        % regularly save the updated data file
        AllData=PAR_Data;
        save(fullFilename, 'AllData');    

        if( params.haveABreak * floor(runCount/params.haveABreak) == runCount )
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            disp(' ');
            disp(sprintf('***************************************************************'));
            disp(' ');
            disp(sprintf('Thank you. Have a short break.'));
            input(sprintf('Press "Enter" when you are ready to proceed.'));
        end
        runCount = runCount+1;
        
        % finished recording auditory bip
        P=audioplayer(beepSound,beepSoundFs);
        play(P);
        %disp('Trial duration was:');
        %toc
        
end

disp(sprintf('***************************************************************'));
disp(' ');
disp(sprintf('Thank you. This part of the experiment is now over.'));


    
