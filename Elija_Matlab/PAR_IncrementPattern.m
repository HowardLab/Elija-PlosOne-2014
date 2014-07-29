function PAR_Data = PAR_IncrementPattern(PAR_Data)
% move to next pattern
    
    % get number of entries in this cluster
    entriesInCluster = PAR_Data.Cluster(PAR_Data.clusterIdx).EntriesInCluster;
           
    % inc cluster member index if not the last
    if(PAR_Data.clusterMemberIdx < entriesInCluster  && PAR_Data.Cluster(PAR_Data.clusterIdx).RunningRewardCnt < PAR_Data.ClusterBoredomCount)
       	
        % move to next cluster member
        PAR_Data.clusterMemberIdx = PAR_Data.clusterMemberIdx+1;       
    else  
       
        % first reset previous running count
        PAR_Data.Cluster(PAR_Data.clusterIdx).RunningRewardCnt = 0;            

        % check if cluster was completed
        if(PAR_Data.clusterMemberIdx == entriesInCluster)            
                PAR_Data.Cluster(PAR_Data.clusterIdx).CompletedCnt = PAR_Data.Cluster(PAR_Data.clusterIdx).CompletedCnt+1;            
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % get the next cluster to use 
                    
        % look for next cluster that hasnt been fully played to caregiver
        searching=1;
        attempts=0;
        while(searching)
            
            % increment cluster index
            PAR_Data.clusterIdx=PAR_Data.clusterIdx+1;                        
            if( PAR_Data.clusterIdx > PAR_Data.dataC.clusters)
                PAR_Data.clusterIdx=1;
            end
            
            % stop looking when find cluster that hasnt been completed
            if ( PAR_Data.Cluster(PAR_Data.clusterIdx).CompletedCnt < 1)
                searching=0; 
            end
            attempts=attempts+1;
            
            % after once through, thats it
            if(attempts>PAR_Data.dataC.clusters)
                searching=0;                 
            end
        end
                
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % get the member index point we left off last time
        fv = PAR_Data.Cluster(PAR_Data.clusterIdx).MemberRewardCnt(1);
        switchIdx = find( PAR_Data.Cluster(PAR_Data.clusterIdx).MemberRewardCnt ~= fv);
        if(length(switchIdx) == 0)
            % starting from 1st member
            PAR_Data.clusterMemberIdx = 1;           
        else
            % starting from 1st different member
            PAR_Data.clusterMemberIdx = switchIdx(1);
        end        
    end