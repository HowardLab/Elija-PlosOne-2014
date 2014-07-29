function pars = InterpolateTargets(params, parsStart, parsEnd, length, init)
% interpolationMode=0 cosine interpolate between the two parameter targets
% interpolationMode=1 linearly interpolate between the two parameter targets
% interpolationMode=2 no interpolation, just use end target from start

    % init  blocks
    pars = zeros(1,size(parsStart,2), length);
        
    switch params.interpolationMode
        
        case params.interpolationCosine
            % half-cosine interpolate between the two feature vector positions               
            Amplitude = (parsStart - parsEnd)/2;        
            for idx = 1:length                                  
                pars(:,:,idx) = parsStart  + Amplitude * (cos(pi * idx/length) -1);
            end

        case params.interpolationLinear
            % linearly interpolate between the two feature vector positions
            for idx = 1:length
                w2 = (idx-1)/(length-1);
                w1 = 1 - w2;
                pars(:,:,idx) = parsStart .* w1 + parsEnd .* w2;
            end
    
         case {params.interpolationCriticalDamping, params.interpolationNone}
            % no interpolation between the two feature vector positions
            start=1;
            if(init)
                pars(:,:,1) = parsStart;
                start = 2;
            end            
            for idx = start:length
                pars(:,:,idx) = parsEnd;
            end
            
        otherwise
            message=sprintf('InterpolateTargets: params.interpolationMode undefined %g',  params.interpolationMode);
            error(message);
    end
    
    pars = squeeze(pars);
