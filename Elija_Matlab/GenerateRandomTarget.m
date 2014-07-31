function [target, lb, ub] = GenerateRandomTarget(params, inputTarget)

% Initialize RAND to a different state each time.
rand('state',sum(100*clock))

switch params.vtParamsMode
    case params.vtParamsInfant
         % 15 VTparams
         % set to random values
        target =  (rand(1, 15) - 0.5) * 2 * params.vtParamsLimit;
        
         % but put limits on the range of the parameters
         lb = ones(1,15) * -params.vtParamsLimit;
         ub = ones(1,15) * params.vtParamsLimit;  
        
    case params.vtParamsBoy
         % 20 VTparams 
         % set to random values
        target =  (rand(1, 20) - 0.5) * 2 * params.vtParamsLimit;
        
         % but put limits on the range of the parameters
         lb = ones(1,20) * -params.vtParamsLimit;
         ub = ones(1,20) * params.vtParamsLimit;  
        
    case params.vtParamsInfantTP1
         % 15 VTparams + segmentDuration 
         % set to random values
        target =  (rand(1, 15) - 0.5) * 2 * params.vtParamsLimit;
        target(16) = rand(1,1) * (params.vtParamsLimitDmax - params.vtParamsLimitDmin)  +  params.vtParamsLimitDmin;  
        
         % but put limits on the range of the parameters
         lb = ones(1,15) * -params.vtParamsLimit;
         ub = ones(1,15) * params.vtParamsLimit;  
         lb(16) = params.vtParamsLimitDmin;
         ub(16) = params.vtParamsLimitDmax;  
        
    case params.vtParamsBoyTP1
         % 20 VTparams + segmentDuration 
         % set to random values
        target =  (rand(1, 20) - 0.5) * 2 * params.vtParamsLimit;
        target(21) = rand(1,1) * (params.vtParamsLimitDmax - params.vtParamsLimitDmin)  +  params.vtParamsLimitDmin;  

         % but put limits on the range of the parameters
         lb = ones(1,20) * -params.vtParamsLimit;
         ub = ones(1,20) * params.vtParamsLimit;  
         lb(21) = params.vtParamsLimitDmin;
         ub(21) = params.vtParamsLimitDmax;  

    case {params.vtParamsInfantTPSD, params.vtParamsInfantTPSD_BREATH}
        % 15 VTparams + 15 segmentDuration + 15 startingTimes
        % set to random values
        target(1:15) =  (rand(1, 15) - 0.5) * 2 * params.vtParamsLimit;        
        target(16:25) = rand(1,10) * (params.vtParamsLimitDmax - params.vtParamsLimitDmin)  +  params.vtParamsLimitDmin;          
        target(26:35) = rand(1,10) * (params.vtParamsLimitSmax - params.vtParamsLimitSmin)  +  params.vtParamsLimitSmin;  
        
        % want smaller deviation of Fx
        target(9) =  (rand - 0.5);    
        target(14) =  (rand - 0.5);    
        
        % but put limits on the range of the parameters
        lb = ones(1,15) * -params.vtParamsLimit;
        ub = ones(1,15) * params.vtParamsLimit;  
        lb(16:25) = params.vtParamsLimitDmin;
        ub(16:25) = params.vtParamsLimitDmax;  
        lb(26:35) = params.vtParamsLimitSmin;
        ub(26:35) = params.vtParamsLimitSmax;  
        
        % want smaller deviation of Fx
        lb(9) = -0.5;
        ub(9) = 0.5;  
        lb(14) = -0.5;
        ub(14)= 0.5;  
         
    case {params.vtParamsBoyTPSD, params.vtParamsBoyTPSD_BREATH}
              
        % 20 VTparams + segmentDuration 
         % set to random values
        target(1:20) =  (rand(1, 20) - 0.5) * 2 * params.vtParamsLimit;        
        target(21:30) = rand(1,10) * (params.vtParamsLimitDmax - params.vtParamsLimitDmin)  +  params.vtParamsLimitDmin;          
        target(31:40) = rand(1,10) * (params.vtParamsLimitSmax - params.vtParamsLimitSmin)  +  params.vtParamsLimitSmin;  

        % want smaller deviation of Fx
        target(9) =  (rand - 0.5);    
        target(19) =  (rand - 0.5);    
        
        % start from sensible choise
        target(10) = -0.5;  % breath in
        target(20) = 0.5;   % breath out
          
        % but put limits on the range of the parameters
        lb = ones(1,20) * -params.vtParamsLimit;
        ub = ones(1,20) * params.vtParamsLimit;  
        
        % want smaller deviation of Fx
        lb(9) = -0.5;
        ub(9) = 0.5;  
        lb(19) = -0.5;
        ub(19) = 0.5;  
        
        lb(21:30) = params.vtParamsLimitDmin;
        ub(21:30) = params.vtParamsLimitDmax;  
        lb(31:40) = params.vtParamsLimitSmin;
        ub(31:40) = params.vtParamsLimitSmax;  
        
    case {params.vtParamsOneTarget, params.vtParamsOneTargetFixDur}
         % 10 VTparams
         % set to random values
         target =  (rand(1, 10) - 0.5) * 2 * params.vtParamsLimit;
        
         % but put limits on the range of the parameters
         lb = ones(1,10) * -params.vtParamsLimit;
         ub = ones(1,10) * params.vtParamsLimit;  
         
        % want smaller deviation of Fx
        lb(9) = -0.5;
        ub(9) = 0.5;  
                    
    case params.vtParamsCrandV   
        
         % 20 VTparams + segmentDuration 
         % set to random values
        target =  (rand(1, 10) - 0.5) * 2 * params.vtParamsLimit;
        target(11:20) =  inputTarget;               
        target(21) = rand(1,1) * (params.vtParamsLimitDmaxCV - params.vtParamsLimitDminCV)  +  params.vtParamsLimitDminCV;  
         
         % but put limits on the range of the parameters
         lb = ones(1,20) * -params.vtParamsLimit;
         ub = ones(1,20) * params.vtParamsLimit;  
         
        % want smaller deviation of Fx
        lb(9) = -0.5;
        ub(9) = 0.5;  
        lb(19) = -0.5;
        ub(19) = 0.5;           
        lb(21) = params.vtParamsLimitDminCV;
        ub(21) = params.vtParamsLimitDmaxCV;  
        
    case params.vtParamsVCrand   
        
         % 20 VTparams + segmentDuration 
         % set to random values
        target =  inputTarget;
        target(11:20) =  (rand(1, 10) - 0.5) * 2 * params.vtParamsLimit;        
        target(21) = rand(1,1) * (params.vtParamsLimitDmaxCV - params.vtParamsLimitDminCV)  +  params.vtParamsLimitDminCV;  
         
        % but put limits on the range of the parameters
        lb = ones(1,20) * -params.vtParamsLimit;
        ub = ones(1,20) * params.vtParamsLimit;  
         
        % want smaller deviation of Fx
        lb(9) = -0.5;
        ub(9) = 0.5;  
        lb(19) = -0.5;
        ub(19) = 0.5;           
        lb(21) = params.vtParamsLimitDminCV;
        ub(21) = params.vtParamsLimitDmaxCV;  
         
    otherwise
        disp('InitMotorTargetMemory:: InitMotorTargetMemory undefined');
        return;
end



