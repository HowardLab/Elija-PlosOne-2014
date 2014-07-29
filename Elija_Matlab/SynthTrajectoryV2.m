function [outputBuffer, TubeCSA] = SynthTrajectoryV2(params, vtpars)
% syntheise speech output from parameter trajectory
% replay some as well

    if(params.wantInit==1)        
        disp('Running SynthTrajectory::VTS_Initialise');
        failed = calllib(params.libname, 'VTS_Initialise', params.samplerate, 1, params.VTsize);
        pause(1);
        if(failed)
            error(['SynthTrajectoryV2::VTS_Initialise failed: ' params.libname]);
        end
        % now call reset
    	calllib(params.libname,'VTS_Reset',flags);        
    end

        
    % set sound samples length 
    len = size(vtpars,2);        
    dbuf = zeros(1,len);    
    PPDS=240;
    PPframeSize=17;
    PPframeCnt=floor(len/PPDS+1);
    TubeCSA = zeros(PPframeSize, PPframeCnt);
    

    if(params.version < 3)
        
        [failed, o1, outputBuffer, TubeCSA, frameSize, frameCnt] = calllib(params.libname, 'VTS_SynthBlockPP', 0, vtpars(:),size(vtpars,1), dbuf, len, TubeCSA, PPDS, PPframeSize, PPframeCnt);    
        if(failed)
            error(['VTS_SynthBlockPP failed: ' params.libname]);
        end
        
    else
        [failed, o1, outputBuffer, TubeCSA, frameSize, frameCnt] = calllib(params.libname, 'VTS_SynthBlockPP', vtpars(:),size(vtpars,1), dbuf, len, TubeCSA, PPDS, PPframeSize, PPframeCnt);    
        if(failed)
            error(['VTS_SynthBlockPP failed: ' params.libname]);
        end
    end
    
    % save outputBuffer
    fid = fopen('out.txt', 'wt');
    fprintf(fid, '%g\n', outputBuffer);
    fclose(fid)

    % save vtpars(:)
    fid = fopen('exp.txt', 'wt');
    fprintf(fid, '%g\n', vtpars(:));
    fclose(fid)


    
if(0)
    % plot proprioceptive output
    figure
    hold on
    plot(vtpars(5,1:PPDS:end)', 'r');
    plot(TubeCSA(17,:),'b');
    legend('VT Parameters p=5, lips', 'proprioceptive output, x-17, lips');
    title('VTPars and Proprioception');
end

