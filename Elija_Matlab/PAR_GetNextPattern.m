function [PAR_Data, motorTargetMemory, targetIdx, erc] = PAR_GetNextPattern(PAR_Data)

    % go through clusters
    motorTargetMemory = [];  
    data=PAR_Data.motorTargetMemory;

    % find all original targets that belong to this prototype
    cidxs = find(PAR_Data.dataC.clusterAllocations == PAR_Data.clusterIdx);

    % get number of entries in this cluster
    entriesInCluster = size(cidxs,1);
     
    % get the next raw target for this cluster
    targetIdx = cidxs(PAR_Data.clusterMemberIdx);
    
    % get specified target memory
    motorTargetMemory.target(1,:) = data.target(targetIdx,:);
    motorTargetMemory.targetsWidth(1,:) = data.vectorWidth;   

    erc = PAR_Data.motorTargetMemory.externalRewardCnt(targetIdx);    

    % progress
    % disp(sprintf('clusterIdx=%d / clusterMemberIdx=%d', PAR_Data.clusterIdx, PAR_Data.clusterMemberIdx));
