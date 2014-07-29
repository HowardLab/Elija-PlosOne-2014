function timeDataCut = SoundDetector(timeData, sampleRate, frameRate, debug)
% detect sound and cut out silence


% plot speech data and simple analysis
win = hanning(1024);
shift = sampleRate/frameRate;


% bandstop filter
N=8;
W1=(2 * 300/sampleRate);
W2=(2 * 6000/sampleRate);
Wn = [W1 W2];
[BL,AL] = butter(N,Wn);

% linear HPF
% Y = FILTER(B,A,X) filters the data in vector X with the
% filter described by vectors A and B to create the filtered
% data Y.             
BPFInput = filter(BL,AL,timeData);      

STP = GetShortTermPower(BPFInput', win, 256);
len = length(STP);
soundDetector = zeros(size(STP));
 
% set threshold from start of utterance
threshold = mean(STP(1:floor(len/10))) * 10;

% now normalize amplitude of input
%maxVal = 1e-3 + max(abs(timeData));
%timeData = timeData/maxVal;

% find 3 consecutive frame values over threshold
tidx = find( (STP(1:(end-2)) > threshold)  & (STP(2:(end-1)) > threshold)& (STP(3:(end)) > threshold) );
soundDetector(tidx) = 1;

if(length(tidx) == 0)
    % disp('SoundDetector failed: using entire input waveform!!!');
    timeDataCut = timeData;
    return;
end

% relain extra frames around threhold region
retainFrames = 30;
first = tidx(1) - retainFrames;
if(first < 1)
    first=1;
end
last = tidx(end) + retainFrames;
if(last > len)
    last = len;
end

% set detector bourdaries
soundDetectorBoundaries(first:last) = 2;

% cut speech
speechfirst = shift*first;
speechlast = shift*last;
timeDataCut = timeData(speechfirst:speechlast);

if(debug)
    figure
    subplot(4,1,1)
    plot(timeData);
    title('waveform');
    subplot(4,1,2);
    plot( STP);
    title('short term power');
    subplot(4,1,3);
    hold on
    plot( soundDetector,'b');
    plot( soundDetectorBoundaries,'r');
    title('over threshold'); 
    subplot(4,1,4)
    plot(timeDataCut);
    title('cut waveform');
end

