function LogScaleB = auditoryFilterbank(speechData, fs)
dynamicRange =  50;
wantLogscale=0;
wantDisplay=0;

% TEST dont used filterback calls
%LogScaleB = [];
%return;

% filterbank control parameters
TWIN = 0.05; 
THOP = 0.020; 
N = 64; 
FMIN = 100; 
FMAX = 12000; 
USEFFT = 0; 
WIDTH = 1.0;
    
% fast FFT gamma tone filterbank 
B = gammatonegram(speechData,fs,TWIN,THOP,N,FMIN,FMAX,USEFFT,WIDTH);

% calculate amplitude 50dB down from maximum
bmin=max(max(abs(B)))/dynamicRange;

if(wantLogscale)   
    % compute top dynamicRange as image
    LogScaleB  = 20*log10(max(abs(B),bmin)/bmin);
else
    LogScaleB  = max(abs(B),bmin) - bmin;    
end    

if(wantDisplay)
    figure
    subplot(2,1,1);
    hold on
    xlabel('Time sample');
    ylabel('Amplitude)');
    title('Waveform');
    plot(speechData);
    
    
    subplot(2,1,2);
    hold on
    title('Filterbank output');
    % plot top 50dB as image
    imagesc(LogScaleB);

    % label plot
    axis xy;
    xlabel('Time frame');
    ylabel('Frequency band)');

    % build and use a grey scale
    lgrays=zeros(100,3);
    for i=1:100
        lgrays(i,:) = 1-i/100;
    end
    colormap(lgrays);
end
