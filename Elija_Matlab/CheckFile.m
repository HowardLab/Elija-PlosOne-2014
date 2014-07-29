function fileExist  = CheckFile(fullFilename)
% if file exits, check if want to proceed

% if filename exists
if(length(fullFilename) > 0)
    % check to see if file already exists
    fullFilenameAN2 = sprintf('%s.mat', fullFilename);
    fid = fopen(fullFilenameAN2,'r');

    % if file does not exist then proceed
    if(fid == -1)
        fileExist=false;
        disp('File does not exists');
        return;
    end

    % if file exists, close it
    % check we want to proceed
    fclose(fid); 
end

% else it exists
fileExist=true;
