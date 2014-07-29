function sumSTPower = AnalyseExtSpeechSalience(params, speechInput, debug)
% run synhtesis and analysis of sensory consequences

% HPF filter
N=8;
W1=(2 * 300/params.samplerate);
[BL,AL] = butter(N,W1,'high');

% linear HPF
% Y = FILTER(B,A,X) filters the data in vector X with the
% filter described by vectors A and B to create the filtered
% data Y.             
BPFInput = filter(BL,AL,speechInput);      

if(0)
FREQZ(BL,AL,128, params.samplerate);    
figure
subplot(1,2,1);
hold on
plot(speechInput);
subplot(1,2,2);
hold on
plot(BPFInput);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
% discard first and last frames
% to get rid of glitches 
cutend = params.cutEndVocoderFrames * params.samplerate/params.framerate;
cutstart = params.cutStartVocoderFrames * params.samplerate/params.framerate;

% cut
BPFInput = BPFInput(:,cutstart: (end-cutend));

% get window for short-term analysis
win = hanning(1024);
shift = params.samplerate/params.framerate;

% compute short term power over speech bandwidth
STPower = GetShortTermPower(BPFInput, win, shift);
       
% root sum power
sumSTPower= sqrt(sum(STPower));

