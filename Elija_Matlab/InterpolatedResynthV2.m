function [resynthOutputBuffer, filkteredvtparams, TubeCSA] = InterpolatedResynthV2(params,vtparams, interpolation)
%  interpolate input parameters and resynthesise speech using VT synth


% reformat
vtparams = vtparams';

if(0)
    figure
    hold on
    plot(vtparams(1,:),'b','linewidth',2);
    plot(vtparams(2,:),'g','linewidth',2);
    plot(vtparams(3,:),'r','linewidth',2);
    plot(vtparams(4,:),'c','linewidth',2);
    plot(vtparams(5,:),'m','linewidth',2);
    plot(vtparams(6,:),'y','linewidth',2);
    plot(vtparams(7,:),'k','linewidth',2);
    plot(vtparams(8,:),'b--','linewidth',2);
    plot(vtparams(9,:),'g--','linewidth',2);
    plot(vtparams(10,:),'r--','linewidth',2);
    title('Maeda parameter trajectories before InterpolatedResynth');
    legend('1.JAW','2.TDP','3.TDS','4.TAP','5.LH','6.LP','7.JH','8.V','9.F','10.');
end


if(interpolation==1)
    vtparsInterpolated = vtparams;
else    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % This goes in the InterpolatedResynth function because it is really a
    % part of the synthesiser
    % filter the VT parameters
    % filterMode = 0 for no filter
    % filterMode = 1 for median filter
    % filterMode = 2 for butterworth LPF
    vtparams = FilterVTParamsV2(vtparams, params);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % interpolate slowly varying vt parameters

    % get sizes
     d1 = size(vtparams,1);
     d2 = size(vtparams,2);

     % alloc destination
     vtparsInterpolated = zeros(d1,d2 *interpolation);
   
     % first value
     vtparsStart = vtparams(:, 1)';
     lastEnd=0;
     lastCnt=0;
          
     for loop = 2:d2
                       
             % get end
             vtparsEnd = vtparams(:, loop)';
                                                                        
             % somehow interpolate between the two vtpar values, specified
             % by params.interpolationMode 
             % now just do linear interpolation to get upto synthresiser
             % frame rate
             % only do linear interpolation here
             params.interpolationMode = params.interpolationLinear;
             vtparsTmp = InterpolateTargets(params, vtparsStart, vtparsEnd, interpolation);
                          
             %  append
             newLen = size(vtparsTmp,2);                  
             vtparsInterpolated(:,lastEnd+1:lastEnd+newLen) = vtparsTmp(:,:);                        

             % update end point
             lastEnd = lastEnd+newLen;             
             
             % update starting vowel
             vtparsStart=vtparsEnd;             
    end      
end

% return filtered vt params
filkteredvtparams  = vtparams;
if(0)
    figure
    hold on
    plot(vtparsInterpolated(1,:),'b','linewidth',2);
    plot(vtparsInterpolated(2,:),'g','linewidth',2);
    plot(vtparsInterpolated(3,:),'r','linewidth',2);
    plot(vtparsInterpolated(4,:),'c','linewidth',2);
    plot(vtparsInterpolated(5,:),'m','linewidth',2);
    plot(vtparsInterpolated(6,:),'y','linewidth',2);
    plot(vtparsInterpolated(7,:),'k','linewidth',2);
    plot(vtparsInterpolated(8,:),'b--','linewidth',2);
    plot(vtparsInterpolated(9,:),'g--','linewidth',2);
    plot(vtparsInterpolated(10,:),'r--','linewidth',2);
    title('Maeda parameter trajectories after InterpolatedResynth');
    legend('1.JAW','2.TDP','3.TDS','4.TAP','5.LH','6.LP','7.JH','8.V','9.F','10.');
end

% syntheise speech output from parameter trajectory
params.wantInit=0;
[resynthOutputBuffer, TubeCSA] = SynthTrajectoryV2(params, vtparsInterpolated);

if(0)
% scale to +/- (1.0-delta) for .wav representation
maxVal = max(resynthOutputBuffer);
minVal = min(resynthOutputBuffer);        
maxRange = max([abs(maxVal), abs(minVal)]);
if(maxRange>0)
    scaleing = 1/(maxRange + 1e-3);
    resynthOutputBuffer = resynthOutputBuffer * scaleing;
end
end
