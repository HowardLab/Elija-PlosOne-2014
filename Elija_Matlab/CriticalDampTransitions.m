function dataOut = CriticalDampTransitions(dataIn, beta, betaScale, betaScaleIdx, samplerate, debug)
% smooth between targets with critically damped 2nd order system

    % get size
    [articulators, length] = size(dataIn);

    % output
    dataOut = zeros(articulators, length);

    % init start index
    sidx=1;
    running=1;
    
    % starting position for given articulator section
    startTarget  = dataIn(sidx);
    
   disp(sprintf('dataIn: %g\n', dataIn));
    
    % until end found
    loopcnt=0;
    while(running)
                
        % starting position for given articulator section
        startPoint = dataIn(sidx);
        
        % find where transitions occurs
        fidxList = find( dataIn(sidx:end) ~= startPoint);        
        
        if(isempty(fidxList))
            eidx = length;
        else
            fidx = fidxList(1);
            eidx = fidx+sidx-1;
        end

        % check for termination
        if(eidx >= length)
            running =0;
        end

        % ending position for given articulator section
        endPoint = dataIn(eidx-1);
        
        % get length of section
        timeSteps = eidx-sidx+1;
        
        message=sprintf('sidx=%g starP=%g starT=%g eidx=%g etar=%g', sidx, startPoint, startTarget,eidx, endPoint);
        disp(message);

        % compute critically damped trajectory  
        region=betaScaleIdx(sidx);
        betaV = beta * betaScale(region);        
        x = ComputeCDT(startTarget, endPoint, timeSteps, betaV, samplerate);
            
        %figure
        %plot(x);
            
        % get lengths    
        lenOld = sidx;
        lenNew = size(x,2);     
        lenTotal = lenOld + lenNew;
                
        %lenOld
        %lenNew
        %lenTotal
        
        % put new part in 
        dataOut(lenOld:(lenTotal-1)) = x(:,:);    

        % update start index
        sidx = eidx;
        
        % next starting position for given articulator section
        % comes from where it was at last time
        startTarget =  x(:,end);
        
        % default stop
        loopcnt = loopcnt+1;
        if(loopcnt == length)
            running=0;
        end
    end

    if(debug)
        figure
        hold on
        plot(dataIn(:)','r')
        plot(dataOut(:)','b')
        legend('Input data', 'Output data');
        hold off
    end


