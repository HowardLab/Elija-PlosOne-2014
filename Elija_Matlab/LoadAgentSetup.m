
function [setup, loaded]  = LoadAgentSetup(fullFilename)
% read in existing setup file

setup =[];
loaded = false;

% check file exixts
fileExist  = CheckFile(fullFilename);

if(fileExist)
    disp(sprintf('LoadAgentSetup: Loading setup fileName=%s', fullFilename));
    load(fullFilename);
    loaded = true;
else
    disp(sprintf('LoadAgentSetup: Cant load fileName=%s', fullFilename));
end
