function filteredOutput = FilterVTParams(predictedOutput,params);
% filter the VT parameters
% mode = 1 for median filter
% mode = 2 for butterworth LPF

% none  at all
if(params.filtermode == 0)
     filteredOutput = predictedOutput;
end

% median
if(params.filtermode == 1)

    % loop over all target parameters
    for idx = 1:size(predictedOutput,1)    
        % used median filter
        filteredOutput(idx, :) = medfilt1(predictedOutput(idx,:), params.medianFilterWindow);
    end    
             
end

% butterworth
if(params.filtermode == 2)

    %[B,A] = BUTTER(N,Wn) designs an Nth order lowpass digital
    %Butterworth filter and returns the filter coefficients in length 
    %N+1 vectors B (numerator) and A (denominator). The coefficients 
    %are listed in descending powers of z. The cutoff frequency 
    %Wn must be 0.0 < Wn < 1.0, with 1.0 corresponding to 
    %half the sample rate.
    [B,A] = BUTTER(params.LPFpoles, params.LPFcutoff/params.LPFSamplingFreq);
    %FREQZ(B,A,128, 100);
    
    filteredOutput = [];
    % loop over all target parameters
    for idx = 1:size(predictedOutput,1)    
        
        % linear LPF
        % Y = FILTER(B,A,X) filters the data in vector X with the
        % filter described by vectors A and B to create the filtered
        % data Y.     
        
        ut = filter(B,A,predictedOutput(idx,:));      
        filteredOutput(idx,:) = ut;         
    end
    
    % correct for LPF delay
    % shift by xxx frames
    delay = 8;
    filteredOutput = filteredOutput(:, 1+delay:end);    
end
    