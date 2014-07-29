function [scalarEvaluation, sumSpectrogramNDiffF, sumHPFSTContact, sumLPFPower, sumLFversusHFratio, sumHFversusLFratio] = GetSensoryConsequencesEvaluation(params, sensoryConsequences)
% scalarEvaluation is evaluated value of the gesture



% scale & sum narrowband spectral differences
sumSpectrogramNDiffF=  mean(sensoryConsequences.spectrogramNDiffF) * params.weight.spectrogramNDiffF;

% scale & sum  power
sumLPFPower = mean(sensoryConsequences.LPFSTPower)  * params.weight.LPFSTPower;


% want binaty contact signal across VT for salience
sumHPFSTContact = max(mean(sensoryConsequences.VectorContact,2)) * max(params.weight.STContact);

% scale & sum  change in contact
%len=size(sensoryConsequences.HPFSTContact,2);
%sumHPFSTContact = mean(sum( sensoryConsequences.HPFSTContact .* repmat(params.weight.STContact',1,len)) ); 

% scale & sum nasal
sumNasal =  mean(sensoryConsequences.nasal)  * params.weight.nasal;

% get number of contacts simultanbeously at each sample
contactWaveform = sum(sensoryConsequences.VectorContact,1);               
        
% get maximum number of contacts above threshold
contactCount=max(contactWaveform) - params.weight.contactThreshold;
if(contactCount < 0)       
    contactCount = 0;
end

% spectral balance
lfp = mean(sensoryConsequences.SB_LPFoutputPower);
hfp = mean(sensoryConsequences.SB_HPFoutputPower);
if(hfp==0)
        hfp=1e-6;
end
if(lfp==0)
        lfp=1e-6;
end

sumLFversusHFratio = (lfp/hfp) * params.weight.LFversusHF;
sumHFversusLFratio = (hfp/lfp)* params.weight.HFversusLF;


% get tube cross sectional area
 meanTubeCSA = mean(sensoryConsequences.TubeCSA,2);
    
% get minima
[minCSA, minCSAIdx] = min(meanTubeCSA);

% penalize on basis of how far from targe
tubeMinimumReward =  - abs(params.WantTubeMinimumPoint - minCSAIdx)* params.weight.tubeMinimum;

% linear combination of rms level, contact,  effort, spectral diff
scalarEvaluation = sumLPFPower + sumHPFSTContact + sumSpectrogramNDiffF + sumNasal +...
        sumLFversusHFratio  + sumHFversusLFratio  +...
        contactCount * params.weight.multipleTongueContacts + tubeMinimumReward ; 




