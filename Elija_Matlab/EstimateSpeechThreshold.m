function [speechPresentThresold, failed] = EstimateSpeechThreshold(params,  dirOut, filename)
% estimate speech present threshold

% init
extSpeechSalience = [];
extSilenceSalience = [];
UtteranceCount = 5;

% set weighinging for acoustic power
utilityWeighing = zeros(1,params.utilityWeighingVectorLen); % 
utilityWeighing(18) = 1;    % power

% file directory
fullFilename = sprintf('%s\\%s', dirOut, filename);

% make output directory
mkdir(dirOut);
close all
clc
disp(sprintf('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++'));
disp(' ');
disp(sprintf('                 Voice Level Calibration'));
disp(' ');
disp(sprintf('Position the microphone near your mouth, but to one side'));
disp(' ');
disp('Please speak in a normal voice and say the numbers that appear on the screen');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% record speech utterances
for jidx = 1:UtteranceCount
                              
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    disp(' ');
    input(sprintf('Press "Enter" and then say this number: %g', jidx));

    % record at params.samplerate, params.bits bit
    params.bits = 16;
    lenInSecs = 1.5;
    recorder  = audiorecorder(params.samplerate, params.bits, 1);
    recordblocking(recorder, lenInSecs);
    mimicSpeech = getaudiodata(recorder , 'double');     
        
    disp(sprintf('Analysing...'));

    % now replay sound
    P = audioplayer(mimicSpeech, params.samplerate);
    play(P);
    
    % weighting for salience
    % run optimization
    params = SetUtilityWeighting(params, utilityWeighing);
    
    % get salience measure of input speech
    extSpeechSalience(jidx) = AnalyseExtSpeechSalience(params, mimicSpeech', 0);   
                
    % save speech for all targets as wav files
    outputFilename = sprintf('%s/Speech_%s_%g.wav', dirOut, filename, jidx);
        
    SaveAsWav(params, mimicSpeech, outputFilename);
    disp(sprintf('Salience=%4.3f', extSpeechSalience(jidx)));
end


disp(' ');
disp(sprintf('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++'));
disp(' ');
disp('Now we need to record the background noise level');
disp('We will do this five times. Please remain silent throughout');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% record silence utterances
for jidx = 1:UtteranceCount
                              
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    disp(' ');
    input(sprintf('%g/%g : Press "Enter"', jidx,UtteranceCount));
    
    % record at params.samplerate, params.bits bit
    params.bits = 16;
    lenInSecs = 1.5;
    recorder  = audiorecorder(params.samplerate, params.bits, 1);
    recordblocking(recorder, lenInSecs);
    mimicSpeech = getaudiodata(recorder , 'double');     
        
    disp(sprintf('Analysing...'));

    % now replay sound
    P = audioplayer(mimicSpeech, params.samplerate);
    play(P);
    
    % weighting for salience
    params = SetUtilityWeighting(params, utilityWeighing);
    
    % get salience measure of input speech
    extSilenceSalience(jidx) = AnalyseExtSpeechSalience(params, mimicSpeech', 0);   
                
    % save speech for all targets as wav files
    outputFilename = sprintf('%s/Silence_%s_%g.wav', dirOut, filename, jidx);
        
    SaveAsWav(params, mimicSpeech, outputFilename);
    disp(sprintf('Salience=%4.3f', extSilenceSalience(jidx)));
end

meanSpeechSalience = mean(extSpeechSalience);
minSpeechSalience = min(extSpeechSalience);
maxpeechSalience = max(extSpeechSalience);

meanSilenceSalience = mean(extSilenceSalience);
minSilenceSalience = min(extSilenceSalience);
maxSilenceSalience = max(extSilenceSalience);

ratioMean = meanSpeechSalience/meanSilenceSalience;
ratioMinMax = minSpeechSalience/maxSilenceSalience;

speechPresentThresold = meanSpeechSalience/5;

disp('');
disp(sprintf('Speech to silence power ratio = %4.1f\n', ratioMean));


if(minSpeechSalience < maxSilenceSalience)
    disp(sprintf('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++'));
    disp(sprintf('Error: Quietest silence louder than some speech sounds!!!'));
    disp(sprintf('Reduce background noise or speak louder!!!'));
    disp(sprintf('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++'));
    failed = true;
    return;
end

if(ratioMean < 5)
    disp(sprintf('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++'));
    disp(sprintf('Error: Mean Speech level to Silence is MUCH too low'));
    disp(sprintf('Reduce background noise or speak louder!!!'));
    disp(sprintf('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++'));
    failed = true;
    return;
end

if(ratioMean < 10)
    disp(sprintf('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++'));
    disp(sprintf('Mean Speech level to Silence is  too low'));
    disp(sprintf('Using data but reduce background noise or speak louder!!!'));
    disp(sprintf('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++'));
    failed = true;
    return;
end

disp('');
disp(sprintf('Thank you for calibrating the levels'));

% results OK
failed = false;


   
