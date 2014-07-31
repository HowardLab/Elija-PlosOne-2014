function motorList = DM_InitMotorPatternList(vtParamsDim, vtParamsMinVal, vtParamsMaxVal,...
                                            ppParamsDim, ppParamsMinVal, ppParamsMaxVal,...
                                            scParamsDim, scParamsMinVal, scParamsMaxVal,...
                                            csaParamsDim, csaParamsMinVal, csaParamsMaxVal)
% diversity manager: init list

motorList.entries = 0;

% set ranges
motorList.vtParamsMinVal = vtParamsMinVal;
motorList.vtParamsMaxVal = vtParamsMaxVal;
%
motorList.ppParamsMinVal = ppParamsMinVal;
motorList.ppParamsMaxVal = ppParamsMaxVal;
%
motorList.scParamsMinVal = scParamsMinVal;
motorList.scParamsMaxVal = scParamsMaxVal;
%
motorList.csaParamsMinVal = csaParamsMinVal;
motorList.csaParamsMaxVal = csaParamsMaxVal;

% set dimensions
motorList.vtParamsDim = vtParamsDim;
motorList.ppParamsDim = ppParamsDim;
motorList.scParamsDim = scParamsDim;
motorList.csaParamsDim = csaParamsDim;

% get normalization scalings assuming all parameters have same range
motorList.vtParamsNormScale = 1/(sqrt(vtParamsDim * (vtParamsMaxVal-vtParamsMinVal) ^ 2));
motorList.ppParamsNormScale = 1/(sqrt(ppParamsDim * (ppParamsMaxVal-ppParamsMinVal) ^ 2));
motorList.scParamsNormScale = 1/(sqrt(scParamsDim * (scParamsMaxVal-scParamsMinVal) ^ 2));
motorList.csaParamsNormScale = 1/(sqrt(csaParamsDim * (csaParamsMaxVal-csaParamsMinVal) ^ 2));
