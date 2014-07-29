function PAR_Data = PAR_UpdatePattern(PAR_Data, motorEffort, salience, externalSalience, totalReward)
    % update current pattern with results
    
    % increment 
    PAR_Data.Cluster(PAR_Data.clusterIdx).RunningRewardCnt = PAR_Data.Cluster(PAR_Data.clusterIdx).RunningRewardCnt+1;
    PAR_Data.Cluster(PAR_Data.clusterIdx).RewardCnt = PAR_Data.Cluster(PAR_Data.clusterIdx).RewardCnt+1;
    PAR_Data.Cluster(PAR_Data.clusterIdx).MemberRewardCnt(PAR_Data.clusterMemberIdx) =  PAR_Data.Cluster(PAR_Data.clusterIdx).MemberRewardCnt(PAR_Data.clusterMemberIdx)+1;                
        
    % find all original targets that belong to this prototype
    cidxs = find(PAR_Data.dataC.clusterAllocations == PAR_Data.clusterIdx);

    % get number of entries in this cluster
    entriesInCluster = size(cidxs,1);
     
    % get the raw target for this cluster
    targetIdx = cidxs(PAR_Data.clusterMemberIdx);
                
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % record evaluated parameters
    
    % increment reward counter
    PAR_Data.motorTargetMemory.externalRewardCnt(targetIdx) = PAR_Data.motorTargetMemory.externalRewardCnt(targetIdx) +1;
    erc = PAR_Data.motorTargetMemory.externalRewardCnt(targetIdx);
        
    % record motor effort
    PAR_Data.motorTargetMemory.motorEffort(targetIdx,erc) = motorEffort;
        
    % record internal salience
    PAR_Data.motorTargetMemory.internalSalience(targetIdx,erc) = salience;
    
    % record external salience of response
    PAR_Data.motorTargetMemory.externalSalience(targetIdx,erc) = externalSalience;
                
    % load total evaluation
    PAR_Data.motorTargetMemory.externalReward(targetIdx,erc) = totalReward;
    
    % move to next pattern
    PAR_Data = PAR_IncrementPattern(PAR_Data);
   




            