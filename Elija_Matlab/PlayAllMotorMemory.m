function [sensoryConsequences, motor, criticalDuration, vtparsOut] = PlayAllMotorMemory(motorTargetMemory, params, wantDebugTraces, silencePadding, wantSaveVTP, outputFilename)
% play out motor memory targets in sequence

sensoryConsequences=[];
motor=[];
criticalDuration=[];

% decode mode    
switch (params.vtParamsMode)        
	case {params.vtParamsOneTarget, params.vtParamsOneTargetFixDur, params.vtParamsCrandV, params.vtParamsVCrand, params.vtParamsInfant, params.vtParamsBoy, params.vtParamsInfantTP1, params.vtParamsBoyTP1}
        
        % single duration parameter
        [sensoryConsequences, motor, criticalDuration] = PlayAllMotorMemoryTP1(motorTargetMemory,...
                                                        params, wantDebugTraces, silencePadding, wantSaveVTP,...
                                                        outputFilename);

    case {params.vtParamsCrandVDBT, params.vtParamsVCrandDBT, params.vtParamsCrandVDBTFixDur}
        
        % duration, beta, type  parameter per target
        [sensoryConsequences, motor, criticalDuration] = PlayAllMotorMemoryDBT(motorTargetMemory,...
                                                        params, wantDebugTraces, silencePadding, wantSaveVTP,...
                                                        outputFilename);                                                            
	case {params.vtParamsInfantTPSD, params.vtParamsBoyTPSD, params.vtParamsInfantTPSD_BREATH, params.vtParamsBoyTPSD_BREATH}
        
        % duration parameter and start time per articulator
        [sensoryConsequences, motor, criticalDuration] = PlayAllMotorMemoryTPSD(motorTargetMemory,...
                                                        params, wantDebugTraces, silencePadding, wantSaveVTP,...
                                                        outputFilename);
    
    case {params.vtParamsFullSet, params.vtParamsFullSetFixDur}
                
        % unpack the 2 targets into linear representation
        motorTargetMemory = UnpackTargetsFullSet(params, motorTargetMemory);    

        % play linear representation
        % duration paramete, betar and start time values defined per articulator target
        [sensoryConsequences, motor, criticalDuration, vtparsOut] = PlayAllMotorMemoryLinear(motorTargetMemory,...
                                                        params, wantDebugTraces, wantSaveVTP,...
                                                        outputFilename);
 
   case {params.vtParamsFullLinearSet, params.vtParamsFullLinearSetFixDur}
        
        % play linear representation
        % duration paramete, betar and start time values defined per articulator target
        [sensoryConsequences, motor, criticalDuration, vtparsOut] = PlayAllMotorMemoryLinear(motorTargetMemory,...
                                                        params, wantDebugTraces, wantSaveVTP,...
                                                        outputFilename);

    otherwise
        disp('PlayAllMotorMemory::vtParamsMode Undefined');
        return;
end

