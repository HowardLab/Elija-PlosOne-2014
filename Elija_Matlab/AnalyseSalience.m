function [prunePower, internalSalience] = AnalyseSalience(params, filenameOut, targetsDir, wantErase)
% compute salience of each sybthesis
% will be used for automatic pruning

% set weighinging for acoustic power
utilityWeighing = zeros(1,params.utilityWeighingVectorLen); 
utilityWeighing(18) = 1;    % power

% add directory
filenameIn = sprintf('%s\\%s', targetsDir, filenameOut);
filenameOut = sprintf('%s\\%s', targetsDir, filenameOut);

% load data file
load(filenameIn);

% dont reanalyse data it takes a long time
if(isfield(AllData.motorTargetMemory,'prunePower'))
    
   % check if we want to proceed with analysis
    wantAnalysis = CheckFileProceed([]);
    if(wantAnalysis==false)
        disp('Not reanalysing data');
        return;
    end
end

% shorthand
data = AllData.motorTargetMemory;

% get entries in data list
entriesData = size(data.target,1);

% loop over all motor memories
for sidx = 1:entriesData

        % progress
        disp(sprintf('Playing %g of %g',sidx,entriesData)); 
        
        % put in the parameters repeated several times in memory
        motorTargetMemory = [];
        motorTargetMemory.target(1,:) = data.target(sidx,:);


       	if( isfield(data, 'targetsWidth') )
        	motorTargetMemory.targetsWidth(1,:) = data.targetsWidth(sidx,:);
        else
        	motorTargetMemory.targetsWidth(1,:) = data.vectorWidth;
        end
        
        motorTargetMemory.internalReward(1,:) = data.internalReward(sidx,:);         
        motorTargetMemory.currentIdx = data.currentIdx;

        % update utility weighting
        params = SetUtilityWeighting(params, utilityWeighing);

        % do synthesis
        [sensoryConsequences, motor, duration] = PlayAllMotorMemory(motorTargetMemory, params, 0, 1, 0, ' ');   
        
        % unity scale
        params.weight.LFversusHF=1;
        params.weight.HFversusLF=1;

        % scalarEvaluation is evaluated value of the gesture
        [salience, sumSpectrogramNDiffF, sumHPFSTContact, sumLPFPower, sumLFversusHFratio, sumHFversusLFratio] = GetSensoryConsequencesEvaluation(params, sensoryConsequences);
        
        % save LF/HF power ratio
        AllData.motorTargetMemory.LFversusHFratio(sidx,:) = sumLFversusHFratio;        
        AllData.motorTargetMemory.HFversusLFratio(sidx,:) = sumHFversusLFratio;        
               
        AllData.motorTargetMemory.prunePower(sidx,:) = sumLPFPower;
        disp(sprintf('index %g/%g   PrunePower:%g   LFtoHFratio=%g\n', sidx, entriesData, sumLPFPower, sumLFversusHFratio));     
        
        % get number of contacts simultanbeously at each sample
        contactWaveform = sum(sensoryConsequences.VectorContact,1);               
        
        % get maximum number of contacts
        contactCount=max(contactWaveform);
        disp(sprintf('Contact[%g] = %g',sidx,  contactCount));
                                
        % add contact count
        AllData.motorTargetMemory.ContactCount(sidx,:) = contactCount;
        
        AllData.motorTargetMemory.internalSalience(sidx,:) = salience;
        AllData.motorTargetMemory.externalSalience(sidx,:) = 0;
        AllData.motorTargetMemory.motorEffort(sidx,:) = motor.motorEffort;
        AllData.motorTargetMemory.internalReward(sidx,:) = -(salience - motor.motorEffort); 
        AllData.motorTargetMemory.externalReward(sidx,:) = 0;
end

% plot the salience values
figure
hold on
title('prunePower');
salienceBins = 50;
hist(AllData.motorTargetMemory.prunePower,salienceBins);
prunePower = AllData.motorTargetMemory.prunePower;
internalSalience = AllData.motorTargetMemory.internalSalience;

% save data files each loop
save(filenameOut, 'AllData');        




