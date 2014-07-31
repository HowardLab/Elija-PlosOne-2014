function vtparsDamped = CriticalDamping(params, vtpars, betaScale)
% smooth between targets with critically damped 2nd order system

% dont do anything unless critical damping selected
if(params.interpolationMode ~= params.interpolationCriticalDamping)
    vtparsDamped = vtpars;
    %disp('Not running CriticalDamping');
    return
end
%disp('Running CriticalDamping');

% get size
[articulators, length] = size(vtpars);

% output
vtparsDamped = zeros(articulators, length);

% cashed lookup table
table = [];

% for each articulator in turn
for aidx = 1:articulators  

    % set beta per articulator channel
    beta =  params.betaTPSD(aidx) * betaScale;
    %disp(sprintf('beta(%g)=%g',aidx,  beta));
    
    % init start index
    sidx=1;
    running=1;
    
    % starting position for given articulator section
    startTarget  = vtpars(aidx,sidx);
    
    % until end found
    loopcnt=0;
    while(running)
                
        % starting position for given articulator section
        startPoint = vtpars(aidx,sidx);
        
        % find where transitions occurs
        fidxList = find( vtpars(aidx, sidx:end) ~= startPoint);        
        
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
        endPoint = vtpars(aidx,eidx-1);
        
        % get length of section
        timeSteps = eidx-sidx+1;
        
        %message=sprintf('sidx=%g star=%g eidx=%g etar=%g', sidx, startPoint, eidx, endPoint);
        %disp(message);
        
        
        % compute critically damped trajectory  
        useTable=0;
        if(useTable)
            [x, table] = ComputeCDTTable(startTarget, endPoint, timeSteps, beta, params.samplerate, table);
        else     
            x = ComputeCDT(startTarget, endPoint, timeSteps, beta, params.samplerate);
        end
                      
        % get lengths    
        lenOld = sidx;
        lenNew = size(x,2);     
        lenTotal = lenOld + lenNew;
                       
        % put new part in 
        vtparsDamped(aidx,lenOld:(lenTotal-1)) = x(:,:);    

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
end

if(0)
figure
hold on
title('Input VTPars');
plot(vtpars(1:6,:)')
legend('1', '2', '3', '4', '5', '6');
hold off

figure
hold on
title('Output VTPars');
plot(vtparsDamped(1:6,:)')
legend('1', '2', '3', '4', '5', '6');
hold off
end

if(0)
figure
hold on
plot(vtpars(1,:)','r')
plot(vtparsDamped(1,:)','b')
legend('Input VTPars', 'Output VTPars');
hold off
end


