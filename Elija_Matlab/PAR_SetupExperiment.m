function PAR_Data =  PAR_SetupExperiment(fullFilename, boredomCount, wantReInit)


    % load data files
    load(fullFilename);

    % get entries in data list
    PAR_Data = AllData;
    PAR_Data.entriesData = size(AllData.motorTargetMemory.target,1);

    % number of times a cluster may be sampled at one go
    PAR_Data.ClusterBoredomCount = boredomCount;
    
    % set motor cluster information
    data=PAR_Data.motorTargetMemory;
    PAR_Data.dataC.bestTarget = data.T1T2bestfullC;        
    PAR_Data.data.vectorWidth  = size(PAR_Data.dataC.bestTarget,2); 
    PAR_Data.dataC.clusterAllocations = data.T1T2idx;
    PAR_Data.dataC.clusters = size(data.T1T2C,1);
    PAR_Data.label='CT1T2';

    
    % init only once or if explicitly requested
    if( isfield(PAR_Data, 'clusterIdx')==0 || wantReInit)    

        disp('PAR_SetupExperiment Initializing from start');
        
        % init clusters
        PAR_Data.clusterIdx = 1;
        PAR_Data.clusterMemberIdx = 1;
                
        % go through clusters
        for clusterIdx=1:PAR_Data.dataC.clusters
                    
            % find all original targets that belong to this prototype
            cidxs = find(PAR_Data.dataC.clusterAllocations == clusterIdx);

            % get number of entries in this cluster
            entriesInCluster = size(cidxs,1);
     
            %  number of times cluster investigated
            PAR_Data.Cluster(clusterIdx).EntriesInCluster =   entriesInCluster;  
            PAR_Data.Cluster(clusterIdx).RewardCnt =   0;  
            PAR_Data.Cluster(clusterIdx).RunningRewardCnt =   0;  
            PAR_Data.Cluster(clusterIdx).CompletedCnt=0;

            % for all cluster entries
            for clusterMemberIdx=1:entriesInCluster    
                
                % get the next raw target for this cluster
                targetIdx = cidxs(PAR_Data.clusterMemberIdx);            

                PAR_Data.Cluster(clusterIdx).TargetIdx(clusterMemberIdx) = targetIdx;                
                PAR_Data.Cluster(clusterIdx).MemberRewardCnt(clusterMemberIdx) = 0;                                
             end    
        end
    end    
    
    


