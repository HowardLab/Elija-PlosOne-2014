function x = ComputeCDT(startPoint, endPoint, steps, beta, samplingRate)
% compute critically damped trajectory

% compute dispacement from equilibrium
DFE = startPoint - endPoint;

% scaled beta
beta2 = beta/samplingRate;

% allocate
x = zeros(1,steps);
 
% for all defined time steps
for tidx = 1:steps          
        
    % should use with V0 = 0
    % x(tidx) = endPoint + (DFE + (time * beta * DFE +  time * V0)) * exp(-beta * time);
    x(tidx) = endPoint + DFE * (1 + (tidx * beta2 )) * exp(-beta2 * tidx);
end
