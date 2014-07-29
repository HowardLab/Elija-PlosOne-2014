function [sensoryConsequences, motor, criticalDuration, vtparsOut] = PlayAllMotorMemoryLinear(motorTargetMemory, params, wantDebugTraces, wantSaveVTP, outputFilename)
% play out motor memory targets in sequence

%disp('PlayAllMotorMemoryLinear');

target = motorTargetMemory.target;
startTime = motorTargetMemory.startTime;
durationTime = motorTargetMemory.durationTime;
betaScale = motorTargetMemory.betaScale;

% process all articulator channels
articulatorChannels = size(target,2);


% generate critically damped step waveform
% first pass to get samples
for aidx = 1:articulatorChannels 
    VTP = GenerateTrajectoryV2(params, params.betaTPSD(aidx), betaScale, target(:,aidx), startTime(:,aidx), durationTime(:,aidx), -1);
    vtSamples(aidx) = length(VTP);
end

% generate critically damped step waveform
% first pass to get data
vtparsOut=[];
lenmax = max(vtSamples);
vtparsOut = zeros(articulatorChannels,lenmax);
vtparsOutT1 = zeros(articulatorChannels,lenmax);
betaT1 = zeros(1,lenmax);
for aidx = 1:articulatorChannels 
    [trajectoryCD, trajectory, trajectoryBeta]  = GenerateTrajectoryV2(params, params.betaTPSD(aidx),  betaScale, target(:,aidx), startTime(:,aidx), durationTime(:,aidx), lenmax);
    len = vtSamples(aidx);
    
    % copy valid samples
    vtparsOut(aidx,1:len) = trajectoryCD(1:len)';
    vtparsOutT1(aidx,1:len) = trajectory(1:len)';
    betaT1(1,1:len) = trajectoryBeta(1:len)';

    % pad with final value
    vtparsOut(aidx,(len+1):lenmax) = trajectoryCD(len)'; 
    vtparsOutT1(aidx,(len+1):lenmax) = trajectory(len)'; 
    betaT1(1,(len+1):lenmax) = trajectoryBeta(len)'; 
end



% now run to get beta and append VTparams with this debugging information
aidx = 1; 
extraChannel=articulatorChannels+1;
    
[trajectoryCD, trajectory, trajectoryBeta]  = GenerateTrajectoryV2(params, params.betaTPSD(aidx),  betaScale, target(:,aidx), startTime(:,aidx), durationTime(:,aidx), lenmax);
len = vtSamples(aidx);
    
% copy valid samples
vtparsOut(extraChannel,1:len) = trajectoryBeta(1:len)';
 % pad with final value
vtparsOut(extraChannel,(len+1):lenmax) = trajectoryBeta(len)'; 

if(0)
figure
subplot(2,1,1)
hold on
title('VT Parameters');
plot(vtparsOut(1,:),'r-','linewidth',2);
plot(vtparsOut(2,:),'g-','linewidth',2);
plot(vtparsOut(3,:),'b-','linewidth',2);
plot(vtparsOut(4,:),'k-','linewidth',2);
plot(vtparsOut(5,:),'m-','linewidth',2);
plot(vtparsOut(6,:),'c-','linewidth',2);
legend('1.JAW','2.TDP','3.TDS','4.TAP','5.LH','6.LP', 'Location','NorthEastOutside');

plot(vtparsOutT1(1,:),'r:','linewidth',2);
plot(vtparsOutT1(2,:),'g:','linewidth',2);
plot(vtparsOutT1(3,:),'b:','linewidth',2);
plot(vtparsOutT1(4,:),'k:','linewidth',2);
plot(vtparsOutT1(5,:),'m:','linewidth',2);
plot(vtparsOutT1(6,:),'c:','linewidth',2);

subplot(2,1,2)
hold on
title('VT beta');
plot(vtparsOut(extraChannel,:),'k-','linewidth',2);
legend('beta', 'Location','NorthEastOutside');
end

% record length
criticalDuration = lenmax/params.framerate;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% scale GA
vtparsOut(8, :) = vtparsOut(8, :) * params.scaleGA;
%disp(sprintf('Hack: Scale GA: %g', params.scaleGA));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% scale Fx
vtparsOut(9, :) = vtparsOut(9, :) * params.scaleFx;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% breathing air fow model
if(params.wantBreathingModel)

        % run as infant
        breathing = GenerateBreathFlow(params, target(:,articulatorChannels), startTime(:,articulatorChannels), durationTime(:,articulatorChannels), lenmax);
        len= length(breathing.airFlow);
        vtparsOut(articulatorChannels, 1:len ) = breathing.airFlow;

        % now modulate voicing using breathing
        % insist on exhalation 
        noBreathingIdx = find((breathing.airFlow <= 0));

        % off when flow less than zero
        preBreathingVoicing = vtparsOut(8, :);
        vtparsOut(8, noBreathingIdx) =  -1;
        disp('Using Breathing');
else
        %disp('Not Using Breathing');
end

% save VTP if requested
if(wantSaveVTP)
    % VTDemo format 3.5
    SaveVTPHuckvaleV3(vtparsOut, params.framerate, outputFilename);
end

% get effort on basis of trajectories
[motor.motorEffort motor.vocalEffort motor.articulatorEffort] =  GetMotorEffort(params, vtparsOut);

if(wantDebugTraces)
 
   figure
    
    subplot(4,1,1);
    hold on
    plot(vtparsOut(1,:),'k','linewidth',2);
    legend('1.JAW', 'Location','NorthEastOutside');
    legend BOXOFF 
    title(('Maeda parameter trajectories') );
    
    subplot(4,1,2);
    hold on    
    plot(vtparsOut(2,:),'k-','linewidth',2);
    plot(vtparsOut(3,:),'k:','linewidth',2);
    plot(vtparsOut(4,:),'k--','linewidth',2);
    legend('2.TDP','3.TDS','4.TAP', 'Location','NorthEastOutside');
    legend BOXOFF 
    
    subplot(4,1,3);
    hold on        
    plot(vtparsOut(5,:),'k-','linewidth',2);
    plot(vtparsOut(6,:),'k:','linewidth',2);
    legend('5.LH','6.LP', 'Location','NorthEastOutside' );
    legend BOXOFF 
    
    subplot(4,1,4);
    hold on        
    plot(vtparsOut(7,:),'k--','linewidth',2);
    plot(vtparsOut(8,:),'k-','linewidth',2);
    plot(vtparsOut(9,:),'k:','linewidth',2);
    plot(vtparsOut(10,:),'b-','linewidth',2);
    legend('7.JH','8.V','9.F','10.N', 'Location','NorthEastOutside');
    legend BOXOFF 

    % Saves current Figure at 600 dpi in color EPS to filename.eps with a
    pname = sprintf('%s',outputFilename );  
    %print('-depsc', '-tiff', '-r600', pname );
    print('-djpeg', '-r600', pname);
    
if(0)
    figure
    subplot(2,1,1);
    hold on
    %plot(preBreathingVoicing,'k--','linewidth',2);
    plot(vtparsOut(10,:) * 300,'k:','linewidth',2);
    plot(vtparsOut(8,:),'k-','linewidth',2);
    title(('Breathing parameter trajectories') );
    %legend('VxWAF', 'AirFlow', 'Vx', 'Location','NorthEastOutside');
    legend('AirFlow', 'Vx', 'Location','NorthEastOutside');
    legend BOXOFF 


    % Saves current Figure at 600 dpi in color EPS to filename.eps with a
    pname = sprintf('%sVTpars_Breath',outputFilename );  
    %print('-depsc2', '-tiff', '-r600', pname );
    print('-djpeg', '-r600', pname);
   
    close all
end

end

% run synthesis and analysis of sensory consequences
wantDebugTraces=1;
sensoryConsequences = AnalyseSensoryConsequences(params, vtparsOut, wantDebugTraces);

% smooth out onset and offset on speech
sensoryConsequences.outputBuffer = SmoothOnsetOffsetV2( sensoryConsequences.outputBuffer, 5000);


