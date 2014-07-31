function updated = PruneOnSpectralBalance(params, filenameIn, filenameOut, targetsDir, wantTestMode)
% prune

% add directory
filenameIn = sprintf('%s\\%s', targetsDir, filenameIn);
filenameOut = sprintf('%s\\%s', targetsDir, filenameOut);

% load data file
load(filenameIn);
AllDataIn = AllData;
clear AllData;

        
% dont reanalyse data it takes a long time
if(isfield(AllDataIn.motorTargetMemory,'LFversusHFratio')==0)
    disp('Run salience analysis then try again');
    updated=0;
    return;
end

% check if we want to proceed with analysis
wantAnalysis = CheckFileProceed(filenameOut);
if(wantAnalysis==false)
	disp('Not reanalysing data');
    updated=0;
	return;
end
     
% shorthand
data = AllDataIn.motorTargetMemory;

% copy params
AllData.params = params;

% get entries in data list
entriesData = size(data.target,1);

% loop over all motor memories
for sidx = 1:entriesData

        % progress
        disp(sprintf('Processing %g of %g',sidx,entriesData)); 
        
        % get random number of repetitions
        data.wantRepeats(sidx,:) = 1; 
        data.externalRewardCnt(sidx,:)=0;           
end


% plot the LFversusHFratio values
figure
hold on
title('LFversusHFratio');
salienceBins = 50;
hist(data.LFversusHFratio,salienceBins);


% get values over external salience
% test less than for debug
%goodIdx = find( abs(data.LFversusHFratio(1:entriesData)) > pruneLFversusLFRatio);
goodIdx = find( abs(data.LFversusHFratio(1:entriesData)) > 10 * abs(data.HFversusLFratio(1:entriesData)));

% in test mode limit to maxPatterns patterms
maxPatterns=50;
if(wantTestMode)
    disp('++++++++++++++++++ run in testmode ++++++++++++++++++++++++');
    disp('Limiting patterns');
   len=length(goodIdx);
   if(len>maxPatterns)
       goodIdx = goodIdx(1:maxPatterns);
   end
end

    
% compute data retained
retainedPercent = 100 * length(goodIdx)/entriesData;
disp(sprintf('Retained entries = %g (%g percent)', length(goodIdx), retainedPercent));

% the most important one first
AllData.motorTargetMemory.target = data.target(goodIdx,:);

AllData.motorTargetMemory.ppParams = data.ppParams(goodIdx,:);
AllData.motorTargetMemory.scParams = data.scParams(goodIdx,:);
AllData.motorTargetMemory.csaParams = data.csaParams(goodIdx,:);

AllData.motorTargetMemory.LFversusHFratio = data.LFversusHFratio(goodIdx,:);
AllData.motorTargetMemory.wantRepeats = data.wantRepeats(goodIdx,:);
AllData.motorTargetMemory.prunePower = data.prunePower(goodIdx,:);
AllData.motorTargetMemory.ContactCount = data.ContactCount(goodIdx,:);
AllData.motorTargetMemory.internalRewardCnt = data.internalRewardCnt(goodIdx,:);
AllData.motorTargetMemory.externalRewardCnt = data.externalRewardCnt(goodIdx,:);
AllData.motorTargetMemory.internalReward = data.internalReward(goodIdx,:);
AllData.motorTargetMemory.externalReward  = data.externalReward(goodIdx,:);
AllData.motorTargetMemory.motorEffort = data.motorEffort(goodIdx,:);
AllData.motorTargetMemory.internalSalience = data.internalSalience(goodIdx,:);
AllData.motorTargetMemory.externalSalience = data.externalSalience(goodIdx,:);
AllData.motorTargetMemory.motorEffort = data.motorEffort(goodIdx,:);
AllData.motorTargetMemory.currentIdx = 1;
AllData.motorTargetMemory.vectorWidth = data.vectorWidth;

% start new index mapping
AllData.motorTargetMemory.SourceIdx = 1:length(goodIdx);

% save data files each loop
save(filenameOut, 'AllData');        

% action taken
updated = 1;



