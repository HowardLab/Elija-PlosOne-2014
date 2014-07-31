function [target, duration] = GetSilencePaddingTP1(params, silencePadding, motorTargetMemory)
% put in initial & final values set to zero to cause clean ramping up/down

% get valid targets 
entries = size(motorTargetMemory.target,1);

% two silences
switch (silencePadding)
    
    case 2   
        % two silence target
        % all vtpapars fully expanded
        target(1,:) = params.SilBoy;
        duration(1) = params.SilBoyDur;
        target(2,:) = params.SilBoy;
        duration(2) = params.SilBoyDur;
        
        target(entries+3,:) = params.SilBoy;
        duration(entries+3) = params.SilBoyDur;
        target(entries+4,:) = params.SilBoy;  
        duration(entries+4) = params.SilBoyDur;     

    case 1
        % one silence target    
        % all vtpapars fully expanded
        target(1,:) = params.SilBoy;
        duration(1,:) = params.SilBoyDur;    
        target(entries+2,:) = params.SilBoy;  
        duration(entries+2) = params.SilBoyDur;    
    
    case 0
        % do nothing here
         duration=motorTargetMemory.duration;
    otherwise
        disp(sprintf('GetSilencePadding: value invalid: %g,', silencePadding ));
        target  =[];
        duration = [];
end


% now copy real data into moddle part
target((silencePadding+1):(entries+silencePadding),:) = motorTargetMemory.target;
duration((silencePadding+1):(entries+silencePadding)) = motorTargetMemory.duration;

