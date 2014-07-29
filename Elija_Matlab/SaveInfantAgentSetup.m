function    SaveInfantAgentSetup(setup)
% save setup file

% full filename
fileName = sprintf('AGENTSETUP_%s_%s', setup.datasetName, setup.experimentName);

% save data
save(fileName, 'setup');

disp(sprintf('SaveInfantAgentSetup::fileName=%s', fileName));
