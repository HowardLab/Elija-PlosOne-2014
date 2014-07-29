 function [experimentName, wordLanguage, caregiverSex] = DisplayProtocolPanel(experimentName, wordLanguage, caregiverSex)
    clc
    disp('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
    disp(sprintf('Running Experiment: %s in %s: subject sex= %s', experimentName, wordLanguage, caregiverSex));
    disp(' ');
    disp('Protocol Reminder Panel');    
    disp(' ');
    disp('Use FilterKeysSet to avoid repeats less than 1 Second');
    disp(' ');
    disp('Ensure Podcaster microphone plugged in and i/o levels suitably set');        
    disp(' ');
    disp('Each subject has unique EXPERIMENTNAME in:');        
    disp('1) Reformulation program - Main_RunInteractReformulations.m');       
    disp('2) Word Imitation program - Interact_NamePictures.m');    
    disp('Each subject has unique wordLanguage in Interact_NamePictures.m');        
    input('Press "Enter" to proceed');