function setup = RunInfantAgentSetup(experimentName, datasetName, wantTestMode, ask)
% manage running of experiments

% full filename
fullFilename = sprintf('AGENTSETUP_%s_%s', datasetName, experimentName);

% check if we want to proceed with analysis
if(ask)
    wantAnalysis = CheckFileProceed(fullFilename);
else
wantAnalysis=1;    
end    
if(wantAnalysis)
    
    % only needed while basic patterns generated without interaction with
    % caregiver
    setup.runOptimizationOnInfantTP1 =0;
    setup.runOptimizationOnBoyTP1 = 0;
    setup.runOptimizationOnInfantTPSD =0;
    setup.runOptimizationOnBoyTPSD = 1;
    setup.playRawSynthesisInfant = 0;
    setup.playRawSynthesisBoy = 0;
    setup.playRawSynthesisInfant = 0;
    setup.playRawSynthesisBoy = 1;    
    setup.runAnalyseSalience  = 1;
    
    setup.CopyReformulateTargets=1;
    setup.CopyReformulateTargets2=1;
    setup.CopyReformulateTargets3=1;

    % needed for a new subject
    setup.experimentName = experimentName;
    setup.pruneOnSalience = 1;
    setup.EstimateSpeechThreshold = 1;
    setup.EstimateSpeechThreshold2 = 1;
    setup.EstimateSpeechThreshold3 = 1;
    
    setup.runClusterMotorSC=1;
    
    setup.runClusterMotorPatterns=1;
    setup.runClusterMotoSensoryConsequences=1;
    setup.PlayAndRecordResponsesPractise = 1
    setup.PlayAndRecordResponses = 1;
    setup.PlayAndRecordResponses2 = 1;
    setup.PlayAndRecordResponses3 = 1;
    
    setup.runConsolidate = 1;
    setup.runConsolidate2 = 1;
    setup.runConsolidate3 = 1;
    
    setup.motorClustersSynthesis = 1;
    setup.analyseReformulationsCaregiver = 1;
    setup.analyseReformulationsInfant = 1;
    setup.namePictures = 1;
    setup.namePicturesMulti = 1;

    % not used in normal operation
    setup.recognizeBestReformulations = 0;
    setup.showPictures = 0;
    setup.labelBestData=0;
    setup.debugMode=0;
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    setup.wantTestMode = wantTestMode;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % c5 = 3
    % C20 = 4
    % C50 = 5
    % C100 = 6
    % C150 = 7
    % C200 = 8
    % C250 = 9
    % 200 cluster centres
    if(setup.wantTestMode)
        setup.clusterMode = 3;
        setup.DTWclusters = 5;  
        setup.maxPictures = 5;
    else
        setup.clusterMode = 9;
        
        % want to cut down reformulation to < 2 hours
        setup.DTWclusters = 1000;        
        setup.DTWCGclusters = 100;
        setup.maxPictures = 75;
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % combined output
    setup.datasetName = datasetName;
    
    % IAH subject name
    setup.subjectName = experimentName;

    setup.dirMotorTargets = sprintf('MotorTargets_%s', setup.datasetName);

    setup.filenameOneTarget =  sprintf('OneTarget_%s', setup.datasetName);
    setup.filenameCV =  sprintf('CV_%s', setup.datasetName);
    setup.filenameCVPruned =  sprintf('CVPruned_%s', setup.datasetName);
    setup.filenameCVReverse =  sprintf('CVReverse_%s', setup.datasetName);
    setup.filenameCVNasalized =  sprintf('CVNasalized _%s', setup.datasetName);
    
    
    setup.filenameBoy =  sprintf('BoyB2T_%s', setup.datasetName);
    setup.filenameInfant =  sprintf('InfantB2T_%s', setup.datasetName);
    
    setup.dirMotorTargetsComb = sprintf('MotorTargets_%s', setup.datasetName);
    setup.filenameBoyCombine = sprintf('AllData_%s', setup.datasetName);

    % pruned on salience    
    setup.filenameBCPruned =  sprintf('BCPruned_%s', setup.datasetName);
    setup.filenameBCPrunedContact =  sprintf('BCPrunedContact_%s', setup.datasetName);
    setup.filenameBCPrunedSalience =  sprintf('BCPrunedSalience_%s', setup.datasetName);

    % KNN cluster motor patterns        
    setup.filenameClusterMotorPatterns =  sprintf('MotorCluster_%s', setup.datasetName);    
    setup.dirConsolidationsWAV = sprintf('Consol_WAV_%s', setup.subjectName);
    setup.dirMotorBestWAV = sprintf('MotorBest_WAV_%s', setup.subjectName);

    
    % DTW cluster SC
    setup.MeansDTWFilenameSC = sprintf('DTWSC_%s', setup.datasetName);  
    setup.DTWSClustersSynthesisFilename = sprintf('DTW_SC_Cluster_%s', setup.datasetName);  
    setup.DTWSClustersBestFilename = sprintf('DTW_SC_CBEST_%s', setup.datasetName);  
    setup.DTWSClusterMemberCountFilename = sprintf('DTW_SC_MemberCount_%s', setup.datasetName);       
    
    % formatted DTW clustered on SC
    setup.LabelListFilename = sprintf('Reform_WAV_%s//LabelsDTW_%s', setup.subjectName, setup.filenameBCPruned);

    
    % for determination of speech / silence  threshold
    setup.dirSpeechSilence = sprintf('SpeSil_WAV_%s', setup.subjectName);
    setup.filenameSpeechSilenceVowels = sprintf('WAV_Vowels_%s', setup.subjectName);
    
    setup.filenameSpeechSilenceCV = sprintf('WAV_CV_%s', setup.subjectName);
    setup.filenameSecondSpeechSilenceCV = sprintf('WAV_CV2_%s', setup.subjectName);

    % specify reformulation location
    setup.dirReformulationsWAV = sprintf('Reform_WAV_%s', setup.subjectName);
    
        
    % filename after consolidation
    setup.filenameConsolidatedVowels = sprintf('Consol_Vo_%s_%s', setup.subjectName, setup.datasetName);
    setup.filenameConsolidatedCV = sprintf('Consol_CV_%s_%s', setup.subjectName, setup.datasetName);
    setup.filenameSecondConsolidatedCV = sprintf('Consol_CV2_%s_%s', setup.subjectName, setup.datasetName);
    setup.filenameSecondPrunedConsolidatedCV = sprintf('Consol_CV2P_%s_%s', setup.subjectName, setup.datasetName);
    
    
    
    setup.filenameSBPrunedC = sprintf('PruneSBC_%s_%s', setup.subjectName, setup.datasetName);

    
    setup.filenameThirdConsolidatedCV = sprintf('Consol_CV3_%s_%s', setup.subjectName, setup.datasetName);

    setup.filenameConsolCV_MotorCluster = sprintf('Consol_CV_MC_%s_%s', setup.subjectName, setup.datasetName);
    setup.filenameConsolC_MotorCluster = sprintf('Consol_C_MC_%s_%s', setup.subjectName, setup.datasetName);

    setup.filenameConsolCVV_MotorCluster = sprintf('Consol_CVV_MC_%s_%s', setup.subjectName, setup.datasetName);
    setup.dirMotorClusterOutWav = sprintf('MotorCluster_WAV_%s', setup.subjectName);

    
    % DTW cluster reformulations
    setup.filenameAnalysed = sprintf('Anal_%s', setup.datasetName);% was subjectName
    setup.MeansDTWFilename = sprintf('DTWC_%s', setup.subjectName);
    setup.DTWClustersSynthesisFilename= sprintf('DTW_Cluster_%s', setup.subjectName);   
        
    % picure naming directory
    setup.dirPictureNamesMultiWAV = sprintf('PicName_multiseg_WAV_%s', setup.subjectName);    

    % for reformulations
    setup.filenameEqualizedTargets = sprintf('Equalized_%s', setup.datasetName);
    setup.filenameCentreTargets = sprintf('Centre_%s', setup.datasetName);
    
    setup.filenameReformKMeans = sprintf('ReformKMmeans_%s', setup.subjectName);
    setup.filenameVowelReformKMeans = sprintf('ReformVowelKMmeans_%s', setup.subjectName);
    setup.filenameCVVowelReformKMeans = sprintf('ReformCVVowelKMmeans_%s', setup.subjectName);
    setup.filenameCReformKMeans = sprintf('ReformCKMmeans_%s', setup.subjectName);
    
   
    setup.filenameSecondReformKMeans = sprintf('ReformSecondKMmeans_%s', setup.subjectName);
    setup.filenameThirdReformKMeans = sprintf('ReformThirdKMmeans_%s', setup.subjectName);
    setup.filenameThirdReformInfantKMeans = sprintf('ReformInfantThirdKMmeans_%s', setup.subjectName);
    
    % for each experiment
    setup.dirExperiment = sprintf('Experiment_%s', setup.subjectName);
    setup.filenameReformulateTargets = sprintf('Reformulate_%s', setup.datasetName);
    setup.filenameSecondReformulateTargets = sprintf('ReformulateSecond_%s', setup.datasetName);
    setup.filenameThirdReformulateTargets = sprintf('ReformulateThird_%s', setup.datasetName);
    
    
    setup.filenameCombine = sprintf('AllData_%s', setup.datasetName);
    setup.filenameCombinePruned  = sprintf('AllDataConPruned_%s', setup.datasetName);
    
    setup.filenameRecombineCVCVV = sprintf('RecombineCVCVV_%s', setup.subjectName);
    setup.filenameRecombineNVF = sprintf('RecombineNVF_%s', setup.subjectName);
    
    setup.filenameRecombAllCVVC = sprintf('RecombAllCVVC_%s', setup.subjectName);

    setup.filenameRecombineCVV = sprintf('RecombineCVV_%s', setup.subjectName);
    setup.filenameRecombineFV = sprintf('RecombineFV_%s', setup.subjectName);
    
    
    % now save setup file
    SaveInfantAgentSetup(setup);
       
else
    % loading existing setup file
    setup = LoadAgentSetup(fullFilename);
end

