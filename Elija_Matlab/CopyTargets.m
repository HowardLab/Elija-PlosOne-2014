function CopyTargets(fileIn, dirIn, fileOut, dirOut);
% copy labels file

% get full filenames
fullFilenameIn = sprintf('%s//%s', dirIn, fileIn);
fullFilenameOut= sprintf('%s//%s', dirOut, fileOut);
mkdir(dirOut);
load(fullFilenameIn);
save(fullFilenameOut, 'AllData');        
