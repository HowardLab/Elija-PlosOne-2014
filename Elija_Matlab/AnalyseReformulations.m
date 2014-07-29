function [ElijaSpeech, CaregiverSpeech] = AnalyseReformulations(params, filename, targetsDir, replayTheshold)
% ana;yse reinforced data on a cluster basis

verbose=0;

% add directory
fullFilename = sprintf('%s\\%s', targetsDir, filename);

% load data files
load(fullFilename);

% init
currentRunCount = 1;
runCount = 1;

disp('Using T1T2 clustered patterns');
data = AllData.motorTargetMemory;
dataC.bestTarget = data.T1T2bestfullC;        
data.vectorWidth  = size(dataC.bestTarget,2); 
dataC.clusterAllocations = data.T1T2idx;
dataC.clusters = size(data.T1T2C,1);
label='CT1T2';

% for all cluster centres
for clusterIdx = 1:dataC.clusters    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % now setup for all intra cluster entries

    % find all original targets that below to this prototype
    cidxs = find(dataC.clusterAllocations == clusterIdx);
    
    % get entries in this cluster
    entriesInCluster = size(cidxs,1);

    if(verbose)
    	disp(sprintf('Cluster %g of %g',clusterIdx,dataC.clusters)); 
    end
    
    % for each entry in this cluster, play the motor pattern and record the output
    reinforcedCnt=0;
    reinforce=[];
    for eidx = 1:entriesInCluster
                
        if(verbose)
            disp(sprintf('AnalyseReformulations::  raw target %g of %g in cluster %g of %g ',eidx,entriesInCluster,clusterIdx,dataC.clusters)); 
        end
        
        % get the next raw target for this cluster
        targetIdx = cidxs(eidx);
                
        % put in the parameters repeated several times in memory
        motorTargetMemory = [];
        motorTargetMemory.target(1,:) = data.target(targetIdx,:);
        motorTargetMemory.targetsWidth(1,:) = data.vectorWidth;
    
        % record external salience of response
        erc = AllData.motorTargetMemory.externalRewardCnt(targetIdx);    

        externalSalience = AllData.motorTargetMemory.externalSalience(targetIdx,erc) ;
        
        
        if(externalSalience > replayTheshold)
            reinforce(eidx)=targetIdx;
            if(verbose)
                disp(sprintf('REINFORCED	erc %g       externalSalience %g ',erc, externalSalience)); 
            end
            reinforcedCnt=reinforcedCnt+1;
        else
            reinforce(eidx)=0;
            if(verbose)
                disp(sprintf('IGNORED       erc %g       externalSalience %g ',erc, externalSalience));                     
            end
        end
    end
    
    
    disp(sprintf('Cluster %g of %g:  reinforced=%g of %g',clusterIdx,dataC.clusters,reinforcedCnt,entriesInCluster)); 
    message = 'reinforce:   ';
    for midx=1:length(reinforce)
        message=sprintf('%s%g   ', message,reinforce(midx));
    end
    disp(message);
    disp(' ');
end


    
