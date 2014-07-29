function wantContinue = PAR_Status(PAR_Data)    
    
wantContinue=0;                
for(cidx = 1:PAR_Data.dataC.clusters)        
    if(PAR_Data.Cluster(cidx).CompletedCnt < 1)                    
        % not finished
        wantContinue=1;                    
    end
end
        
