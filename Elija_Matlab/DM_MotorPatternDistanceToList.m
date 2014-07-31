function [vtMinDist, ppMinDist, scMinDist, csaMinDist]  = DM_MotorPatternDistanceToList(motorList, pidx, vtParams, ppParams, scParams, csaParams)
% diversity manager: get minimum distance for input params to list entry
% the smaller the value for closer matches, large value for bigger differences

% init
vtMinDist=0.01;
ppMinDist=0.01;
scMinDist=0.01;
csaMinDist=0.01;



% exit if no extries
if(motorList.entries==0)
    return
end

% p1 Jaw position
% p2 Tongue dorsum position
% p3 Tongue dorsum shape
% p4 Tongue apex position
% p5 Lip height (aperture)
% p6 Lip protrusion
% p7 Larynx height
% p8 Voicing
% p9 Fundamental frequency
% p10 Breathing
% dont use all vt parameters, just tongue ones
vtRangeIdx=2:4;

% lips - 17
% tongue tip  back of teeth - 15
% tongue tip at alveolar ridge - 14
% tongue tip at top of palette - 8 to 13
% Pharyngeal constriction - 2
csaRangeIdx=6:17;

for eidx = 1: motorList.entries
        
    % euclidian distance
    csaMinDist(eidx) = norm(csaParams(1,csaRangeIdx) - squeeze(motorList.csaParams(eidx,csaRangeIdx)) );
    
    % euclidian distance
    vtMinDist(eidx) = norm(vtParams(1,vtRangeIdx) - squeeze(motorList.vtParams(eidx,vtRangeIdx)) );
    
    % euclidian distance
    ppMinDist(eidx) = norm(ppParams - squeeze(motorList.ppParams(eidx,:)) );
    
    % dp similarity metric, want difference so subtract from unity
    scMinDist(eidx) = 1 - abs(simmx(scParams', squeeze(motorList.scParams(eidx,:))' ));
    
    % enter lange value so min wont find it
    if(eidx==pidx)
        csaMinDist(eidx) = 1000000;
        vtMinDist(eidx) = 1000000;
        ppMinDist(eidx) = 1000000;
        scMinDist(eidx) = 1000000;      
    end
    
end
    

