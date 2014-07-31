function motorList = DM_AddMotorPatternToList(motorList, vtParams, ppParams, scParams, csaParams)
% diversity manager: add MotorPattern to list

% get current index
eidx = motorList.entries+1;

% add motor parameters
if(length(vtParams) > 0)
    motorList.vtParams(eidx,:) = vtParams(:);
end

% add proprioception parameters
if(length(ppParams) > 0)
    motorList.ppParams(eidx,:) = ppParams(:);
end

% add sensory consequences parameters
if(length(scParams) > 0)
    motorList.scParams(eidx,:) = scParams(:);
end

% add tube csa consequences parameters
if(length(csaParams) > 0)
    motorList.csaParams(eidx,:) = csaParams(:);
end

% inc index
motorList.entries = motorList.entries+1;
