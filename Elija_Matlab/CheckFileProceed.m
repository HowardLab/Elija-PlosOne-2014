function wantAnalysis  = CheckFileProceed(fullFilename)
% if file exits, check if want to proceed

% if filename exists
if(length(fullFilename) > 0)
    % check to see if file already exists
    fullFilenameAN2 = sprintf('%s.mat', fullFilename);
    fid = fopen(fullFilenameAN2,'r');

    % if file does not exist then proceed
    if(fid == -1)
        wantAnalysis=true;
        disp('File does not exists, proceeding with analysis ...');
        return;
    end

    % if file exists, close it
    % check we want to proceed
    fclose(fid); 
end

% now check we want to proceed
% ask twice
eraseCount=0;
answer = input('Do you want to proceed with analysis? (Y or N)', 's') 
if(answer == 'Y')
    eraseCount = 1;
    answer = input('Do you REALLY want to proceed with analysis? (Y or N)', 's') 
    if(answer == 'Y')
        eraseCount = 2;
    end
end        
if(eraseCount ~= 2)
	disp('Not Proceeding with analysis ...');
    wantAnalysis=false;
	return;
end
proceed =  true;
disp('Proceeding with analysis ...');  
wantAnalysis=true;

