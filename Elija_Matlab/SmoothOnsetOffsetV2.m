function data = SmoothOnsetOffset(data, duration);
% smooth out onset and offset

    % channels of data
    chans = size(data,1);
    
    % length of the data
    len = size(data,2);
    
    if(2 * duration > len)
     disp(sprintf('Onset+Offset=%g longer than data=%g!', 2 * duration, len));
     duration = len/2;
    end
    duration = floor(duration);

    % for onset and offset put in a linear transition
    sidx = 1:duration;
    scaleOn = (sidx-1)/(duration-1);
    scaleOff = (duration - sidx)/(duration-1);
    
    % for all channels
    for cidx = 1:chans
        % multiply start by scaleOn
        data(cidx,1:duration) = data(cidx,1:duration) .* scaleOn;
        data(cidx,(end-duration+1):end) = data(cidx,(end-duration+1):end) .* scaleOff;
    end
    
