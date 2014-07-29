function [ totalMotorEffort, vocalEffort, articulatorEffort] =  GetMotorEffort(params, vtpars)
% get effort

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute an effort term based on voicing
vocalEffort=[];
vocalEffort = vtpars(8,:) + params.vtParamsLimit;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute articulatory effort
articulators = vtpars(1:8,:);

% get speed of movement
articulatorsSpeed = abs(articulators(:,2:end) - articulators(:,1:(end-1)));

% compute an effort term based on articulator speed and  mass
wts=params.weight.articulatorEffort(1:8)';
articulatorEffort =  articulatorsSpeed .* repmat(wts, 1, size(articulatorsSpeed,2) );

% scale
vocalEffort = vocalEffort * params.weight.vocalEffort;
articulatorEffort = articulatorEffort * params.weight.overallArticulatorEffort;

% sum over artuculators
articulatorEffort = sum(articulatorEffort,1);

% sum values
totalVocalEffort = mean(vocalEffort);
totalArticulatorEffort = mean(articulatorEffort,2);

% return sum          
totalMotorEffort = totalVocalEffort  +  totalArticulatorEffort;


