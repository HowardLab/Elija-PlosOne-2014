% run reformulations
close all
clear all
clc


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% enter name of experiment here !!!
% display infomation                   
[EXPERIMENTNAME, wordLanguage,caregiverSex]  = DisplayProtocolPanel('IANHSESSION5', 'English', 'Male');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% operating flags
playRawData=0;
wantEnter=0;

% setup VTSYNTH
patterns=1000;
ask=0;
[model, params, setup] =  SetupBabbleExperiment('REFORMULATE', EXPERIMENTNAME, patterns, ask);

% Elija's utterance targets
setup.filenameOutALL='OT_ALS_CLOSURE_NOFF4_ALL';
setup.dirOutALL='ALS_CLOSURE_NOFF4_ALL';

% use clustered motor pattern datatset
setup.filenameConsolCV_MotorCluster =  'MOTOR_Cluster_IAN_RAW';
    
params.WantTubeMinimumPoint = 1;
params.overallDurationScale=1;
params.wantBreathFxModel=1;    
params.wantBreathingModel=0;
params.wantClipGA=1;
params.scaleGA=1.0;
params.scaleFx=2;
params.wantNasalScale=0;        
params.wantNasalOn=0;
params.wantNasalOff=0;   
params.wantVoiceOn=0;
params.wantVoiceOff=0;
params.wantVoiceScale=0;          
params.vtParamsMode=params.vtParamsFullSet; 

% copy source list to reformulate
if(setup.CopyReformulateTargets) 
    
    setup.dirReformulationsWAVTEST = sprintf('%s-TEST', setup.dirReformulationsWAV);    
    setup.filenameReformulateTargetsTEST = sprintf('%s-TEST', setup.filenameReformulateTargets);    

    % Real experiment
    % copy list to facility restarting a given experiment
    CopyTargets(setup.filenameConsolCV_MotorCluster, setup.dirOutALL,...
                    setup.filenameReformulateTargets,   setup.dirExperiment);

    % practise experiment
    % copy list to facility restarting a given experiment
    CopyTargets(setup.filenameConsolCV_MotorCluster, setup.dirOutALL,...
                    setup.filenameReformulateTargetsTEST,   setup.dirExperiment);
                
    % done processing
    setup.CopyReformulateTargets = 0;
    
    % now save setup file
    SaveInfantAgentSetup(setup);       
end

% display raw data info for examimation
selectionIdx=[1];
info=DisplayInfo(params, setup.filenameReformulateTargets, setup.dirExperiment, selectionIdx);
info


% play out files for examimation
if(playRawData)
    selectionIdx= [1:2];
    PlaySynthesisWithId(params, setup.filenameReformulateTargets, setup.dirExperiment, selectionIdx,'All');    
end

% discover speech detection threshold
if(setup.EstimateSpeechThreshold)    

    % get external salience threshold
    % depends also on miscrophone and gain
    failed=1;
    
    while(failed)
        [setup.speechPresentThreshold, failed] = EstimateSpeechThreshold(params, setup.dirSpeechSilence, setup.filenameSpeechSilenceCV);
    end
    
    % done processing
    setup.EstimateSpeechThreshold = 0;

    % now save setup file
    SaveInfantAgentSetup(setup);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(setup.PlayAndRecordResponsesPractise)    
       
    % practise run 
    % play out all sounds and record any possible acoustic response from caregiver
    % this will be used to reinforce good actions
    % and to associate reformulations with action
    replayThreshold = setup.speechPresentThreshold;
    params.playGoodResponseCount = 1;
    params.silencePadding=0;
    params.boredomCount=4;    
    params.WantReInit=0;
    params.haveABreak=100;
    wantTestMode = 1;
    PlayAndReformulate(params, setup.filenameReformulateTargetsTEST, setup.dirExperiment, setup.dirReformulationsWAVTEST, params.silencePadding, replayThreshold, wantTestMode);          

    % done processing
    setup.PlayAndRecordResponsesPractise=0;

    % now save setup file
    SaveInfantAgentSetup(setup);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(setup.PlayAndRecordResponses)    
           
    % real experiment
    % play out all sounds and record any possible acoustic response from caregiver
    % this will be used to reinforce good actions
    % and to associate reformulations with action
    replayThreshold = setup.speechPresentThreshold;
    params.playGoodResponseCount = 1;
    params.silencePadding=0;
    params.boredomCount=4;    
    params.WantReInit=0;
    params.haveABreak=100;
    wantTestMode = 0;
    PlayAndReformulate(params, setup.filenameReformulateTargets, setup.dirExperiment, setup.dirReformulationsWAV, params.silencePadding, replayThreshold, wantTestMode);          
    
    % stats on interactions
    AnalyseReformulations(params, setup.filenameReformulateTargets, setup.dirExperiment, replayThreshold);
    
    % done processing
    setup.PlayAndRecordResponses=0;

    % now save setup file
    SaveInfantAgentSetup(setup);
    
    if(setup.debugMode)
        selectionIdx = [1];
        data = DisplayInfo(params, setup.filenameReformulateTargets, setup.dirExperiment, selectionIdx);
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(setup.runConsolidate)   
    
    % only consolidate dataset according to external salience
    externalSalienceTreshold = setup.speechPresentThreshold;
    ConsolidateActionsReactionsV2(params, setup.filenameReformulateTargets, setup.filenameConsolidatedCV, setup.dirExperiment, externalSalienceTreshold);    

    % done processing
    setup.runConsolidate=0;
    
    % now save setup file
    SaveInfantAgentSetup(setup);
    
    if(setup.debugMode)
        selectionIdx = [1];
        data = DisplayInfo(params, setup.filenameConsolidatedCV, setup.dirExperiment, selectionIdx);
    end
    
    if(setup.debugMode)
    
        % now play condolidated
        selectionIdx = [1:1000];
        PlayRawIndividualSynthesisV2(params, setup.filenameConsolidatedCV, setup.dirExperiment, selectionIdx,1 ,0, 1, 0);

        selectionIdx = [1];
        data = DisplayInfo(params, setup.filenameConsolidatedCV, setup.dirExperiment, selectionIdx)
    end
end

% needed  for object labelling task
if(setup.analyseReformulationsCaregiver)
           
    
    % read in reformulation data and compute STFT 
    PlayReformGetSTS(params, setup.filenameConsolidatedCV,  setup.filenameReformulateTargets,  setup.dirExperiment, setup.dirReformulationsWAV);    
    
    % read in reformulation data and compute Fx 
    PlayReformGetFx(params, setup.filenameConsolidatedCV,  setup.filenameReformulateTargets,  setup.dirExperiment, setup.dirReformulationsWAV);    
    
    % cluster the reformulation spectral data
    params.KMeansDTWClusters = 100;
    params.KMeansIterations = 20;
    RunKMeansDTWV2(params,  setup.filenameConsolidatedCV, setup.dirExperiment, setup.filenameReformKMeans, 2);
               
    % play clustered DTW data    
    params.silencePadding=0;
    PlayDTWClustersSynthesisV2(params, setup.filenameReformKMeans, setup.dirExperiment, setup.DTWClustersSynthesisFilename);

    % just best
    %params.silencePadding=0;
    %PlayBestDTWClustersSynthesisV2(params, setup.filenameReformKMeans, setup.dirExperiment, setup.DTWClustersSynthesisFilename);
            
    % done processing
    setup.analyseReformulationsCaregiver=0;

    % now save setup file
    SaveInfantAgentSetup(setup);    
end


% now run imitation list
setup.RecordImitationList=0;
if(setup.RecordImitationList)

    setup.dirExperimentCaregiverList = sprintf('ImitationList-%s', setup.subjectName);
    setup.filenamedCaregiverList = sprintf('%s', setup.subjectName);    
    params.playGoodResponseCount=4;    
    params.WantReInit=0;
    params.haveABreak=50;
    RecordImitationList(params, setup.filenamedCaregiverList,  setup.dirExperimentCaregiverList, wordLanguage);
    
    % done processing
    setup.RecordImitationList=0;

    % now save setup file
    SaveInfantAgentSetup(setup);    
end



