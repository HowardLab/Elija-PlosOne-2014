function data=DisplayInfo(params, filename, targetsDir, selectionIdx)
% display information

% add directory
fullFilename = sprintf('%s\\%s', targetsDir, filename);

% load data files
load(fullFilename);

data = AllData.motorTargetMemory;

AllData.motorTargetMemory

% get entries in data list
entriesData = size(data.target,1);

% loop over all motor memories
entries = size(selectionIdx,2);

for sidx = 1:entries
    
    jidx =  selectionIdx(sidx);

    % check range
    if(jidx <= entriesData)
    
        disp(sprintf('Displaying %g of %g', jidx, entries)); 
        data.target(jidx,:)
     
    end
end
