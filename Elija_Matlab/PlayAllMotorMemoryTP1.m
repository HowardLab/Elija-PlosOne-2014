function [sensoryConsequences, motor, criticalDuration] = PlayAllMotorMemoryTP1(motorTargetMemory, params, wantDebugTraces, silencePadding, wantSaveVTP, outputFilename)
% play out motor memory targets in sequence

% unpack the 2 targets into linear representation
motorTargetMemory = UnpackTargets(params, motorTargetMemory);    

switch params.vtParamsMode
    case {params.vtParamsVCrand, params.vtParamsCrandV   }
        if(silencePadding > 0)
            wantPadding=1;
        else    
            wantPadding=0;
        end
    otherwise
        wantPadding=1;
end
        
if(wantPadding)
    % put in initial & final values set to zero to cause clean ramping up/down
    [target, duration] = GetSilencePaddingTP1(params, silencePadding, motorTargetMemory);
else
    
    % put in initial target twice
    [target, duration] = GetCVPadding(params, motorTargetMemory);
end

% go through all entries
vtparsOut=[];
ridx = 1;
vtparsStart = target(ridx,:);

% for all trials
entries = size(target,1);

% if just started
criticalDuration =  duration(1);

init = 1;
for ridx = 2:entries

    % read target value
    vtparsEnd = target(ridx,:);           
           
    % sample particular transition time
    transitionLength = floor( duration(ridx-1) * params.framerate);
    
    % get first transition duration after padding
    %if((1 + silencePadding) == ridx)
    %    criticalDuration =  duration(ridx);
    %end
    criticalDuration =   duration(ridx-1);

    % interpolate between the two vtpar values
    % NB: Fx also gets  interpolation - this may not be appropriate
    % interpolation mode set by params.interpolationMode
    vtparsTmp = InterpolateTargets(params, vtparsStart, vtparsEnd, transitionLength, init);     
    % now not just started
    init=0;

    %  append
    vtparsOut(:,end+1:end+size(vtparsTmp,2)) = vtparsTmp(:,:);
       
    % update start
    vtparsStart = vtparsEnd;    
        
    % debug only
    %disp(sprintf('ridx=%g/%g', ridx, entries));     
    %disp(sprintf('transition time=%g', motorTargetMemory.duration));    
end

% smooth between targets with critically damped 2nd order system
% only does something if interpolationCriticalDamping mode selected
vtparsOut = CriticalDamping(params, vtparsOut,1);


% scale GA
vtparsOut(8, :) = vtparsOut(8, :) * params.scaleGA;
%disp(sprintf('Hack: Scale GA: %g', params.scaleGA));

% scale Fx
vtparsOut(9, :) = vtparsOut(9, :) * params.scaleFx;

% want Clip GA
if(params.wantClipGA)
    % clip GA at zero
    fidx = find(vtparsOut(8, :) > 0);
    vtparsOut(8, fidx) =0;
    %disp(sprintf('Hack: clip GA > 0'));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% want Voice
if(params.wantVoiceOn)
    vtparsOut(8, :) = 1;
end
if(params.wantVoiceOff)
    vtparsOut(8, :) = -1;
end

% want Voice scale
if( abs(params.wantVoiceScale) > 0)
    vtparsOut(8, :) = vtparsOut(8, :) * params.wantVoiceScale;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% want Nasal
if(params.wantNasalOn)
    vtparsOut(10, :) = 1;
end
if(params.wantNasalOff)
    vtparsOut(10, :) = -1;
end

% want Nasal scale
if(params.wantNasalScale > 0)
    vtparsOut(10, :) = vtparsOut(10, :) * params.wantNasalScale;
end

% if we want basic breathing model
% to modulate Fx on basis of airflow 
% estimated on the basis of voicing
if(params.wantBreathFxModel)
            
        % get voicing
        preBreathingVoicing = vtparsOut(8, :) + params.vtParamsLimit;
        len = size(vtparsOut,2);
        
        % init
        totalVoiocing = sum(preBreathingVoicing);
        FxModulation =  zeros(1,len);
        
        % cumulatibvely sum the voicing signal
        cumSum = zeros(1,len);
        cumSum(1) = preBreathingVoicing(1)/len;
        for idx = 2:len
            cumSum(idx) = cumSum(idx-1) + preBreathingVoicing(idx)/len;
        end
        
        % say has enough for 2 syllables
        % and in full voicing state modulates Fx%
        FxModulation = 1.5 * (cumSum -  cumSum(end)/2);
        
        if(0)
            % debug only
            disp('Using Breath Fx Model');
            figure
            hold on
            plot(cumSum,'r');
            plot(preBreathingVoicing,'b');
            plot(FxModulation,'k');
            legend('cumSum', 'preBreathingVoicing', 'FxModulation');                
        end
        
        % compute Fx pertubation from reduction in pressure
        vtparsOut(9, :) = vtparsOut(9, :) - FxModulation;           
end

% get effort on basis of trajectories
[motor.motorEffort motor.vocalEffort motor.articulatorEffort] =  GetMotorEffort(params, vtparsOut);

if(wantDebugTraces & 0)
    figure
    hold on
    plot(vtparsOut(1,:),'b','linewidth',2);
    plot(vtparsOut(2,:),'g','linewidth',2);
    plot(vtparsOut(3,:),'r','linewidth',2);
    plot(vtparsOut(4,:),'c','linewidth',2);
    plot(vtparsOut(5,:),'m','linewidth',2);
    plot(vtparsOut(6,:),'y','linewidth',2);
    plot(vtparsOut(7,:),'k','linewidth',2);
    plot(vtparsOut(8,:),'b--','linewidth',2);
    plot(vtparsOut(9,:),'g--','linewidth',2);
    plot(vtparsOut(10,:),'r--','linewidth',2);
    title(sprintf('Maeda parameter trajectories: transition time= %g', motorTargetMemory.duration) );
    legend('1.JAW','2.TDP','3.TDS','4.TAP','5.LH','6.LP','7.JH','8.V','9.F','10.N');

% Saves current Figure at 600 dpi in color EPS to filename.eps
pname = sprintf('%sMT',outputFilename);  
%print('-depsc2', '-tiff', '-r600', pname);
print('-djpeg', '-r600', pname);
end

% save VTP if requested
if(wantSaveVTP)
    % old format
    % SaveVTP(vtparsOut, 1.0, params.framerate, outputFilename);
    % VTDemo format 3.5
    SaveVTPHuckvaleV3(vtparsOut, params.framerate, outputFilename);
end

% run synthesis and analysis of sensory consequences
sensoryConsequences = AnalyseSensoryConsequences(params, vtparsOut, wantDebugTraces);

% smooth out onset and offset on speech
sensoryConsequences.outputBuffer = SmoothOnsetOffsetV2( sensoryConsequences.outputBuffer, params.SmoothOnsetOffsetSamples);

