function STP = GetShortTermPower(data, win, shift)
% compute short term power

% format
win = win';

% window length
winLen = length(win);

% input length, accounting for winlen
inLen = length(data) - winLen;

% output length
outLen = floor(inLen/shift);

% alloc output
STP = zeros(1,outLen);

start = 1;
oidx = 1;
done = 0;
while(done==0)
    
    % get local buf
    buf = data(start:(start+winLen-1)) .* win;
    
    % get power
    STP(oidx) =sum( buf .* buf)/winLen;
    oidx=oidx+1;
    % next
    start = 1 + shift * oidx;  
    if(start >= inLen)
        done=1;
    end
end
