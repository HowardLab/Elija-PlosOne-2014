function [VectorContact, ScalarContact] = GetShortTermContact(data, contactThreshold, debug)
% compute short term contact, which occurs if cross section goes below contactThreshold
% just loop for lip closure so start with

if(debug)
    figure
    hold on
    plot(data(10:17,:)');
    legend('10', '11','12','13','14','15','16','17');
    title('PPP');
end


% tube sections
vtTubeLen = size(data,1);

% data samples
dataSamples = size(data,2);

% init output
zeroTube=zeros(vtTubeLen,1);
VectorContact=[];
ScalarContact=[];
for oidx = 1:dataSamples
    
    % get curent vocal tract tube 
    vocalTractTube = data(:, oidx);
            
    %  look for closure in the tube
    fidx = find(vocalTractTube <= contactThreshold);
    tube = zeroTube;
    tube(fidx)=1;
    VectorContact(:, oidx) = tube;
    ScalarContact(oidx) = sum(tube);
end