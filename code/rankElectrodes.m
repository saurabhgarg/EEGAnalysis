function [rank]= rankElectrodes(data, labels, numElectrodes, numFeatures)
% This function rank the electrodes based on the mutual information present
%in each electrode. It calculates MI/electrode/feature and then sum the
%mutual information over all the features and then normalize it.
% data: feature matrix
% lables: Labels (should have same number of rows as data)
% output:
%   rank:  rank of the electrodes in descending order
if nargin < 3
    numElectrodes = 27;
    numFeatures = 27;
end
Y=labels(:);
Hy=entropyF(Y);
for iElect = 1:numElectrodes
    for iFeat = 1:numFeatures
        X=quant(data(iFeat,:)); % quantize the data
        Hx=entropyF(X);
        Hxy=jointentropy(X,Y);
        MI(iElect) = MI(iElect) + (Hx + Hy - Hxy); % sum mutual info over all features
    end
end

[out,rank]=sort(MI,1,'descend');
end

function y = quant(data)
    
    Input = data - min(data); % rearrange the data to start from 0
    quant = max(Input)/(2^7-1);
    y = round(Input/quant) + 1; % start the quantized data from 1
end