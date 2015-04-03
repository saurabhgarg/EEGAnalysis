load('C:\Users\sgarg\Documents\GitHub\EEGAnalysis\code\MATLAB data\feats3D.mat');
load('C:\Users\sgarg\Documents\GitHub\EEGAnalysis\code\MATLAB data\labels.mat');
E= ['E01'; 'E02'; 'E03'; 'E04'; 'E05'; 'E06'; 'E07'; 'E08'; 'E09'; 'E10'; 'E11'; 'E12'; 'E13'; 'E14'; 'E15'; 'E16'; 'E17'; 'E18'; 'E19'; 'E20';
    'E21'; 'E22'; 'E23'; 'E24'; 'E25'; 'E26'; 'E27'; 'E28'; 'E29'; 'E30'; 'E31'; 'E32'; 'E33'; 'E34'; 'E35'; 'E36'; 'E37'; 'E38'; 'E39'; 'E40'; 
    'E41'; 'E42'; 'E43'; 'E44'; 'E45'; 'E46'; 'E47'; 'E48'; 'E49'; 'E50';'E51'; 'E52'; 'E53'; 'E54'; 'E55'; 'E56'; 'E57'; 'E58'; 'E59'; 'E60'; 
    'E61'; 'E62'; 'E63'; 'E64'];
numElectrode=27;
numFeatures=351;
feature=[];
kfold=5;
testeval=[];
for j=1:numFeatures
    for i=1:numElectrode
        feature(1:48,i)=feats3D.(E(i,:))(:,j);
    end
    
    %k fold cross-validation
    indices = crossvalind('Kfold',labels,kfold);
    for i = 1:kfold
        test = (indices == i); train = ~test;
        SVMStruct  = svmtrain (feature(train,:), labels(train,:));
        out_labels  = svmclassify(SVMStruct, feature(test,:));
        true_labels=labels(test,:);
        testeval = [testeval sum(abs(true_labels-out_labels))];
    end
end

%%Random forest for electrode classification:
%TODO: reduce features related to power analysis
%TODO: create N trees per electrode
%NVarToSample  property
%OOBPermutedVarDeltaError -> feature importance
NTrees = 1000;
B = TreeBagger(NTrees,features,labels,'OOBPred','on' ,'OOBVarImp','on');
[Y,scores] = predict(B,Testfeature);
%use scores to calculate the probability of it belonging to a class

%%Feature selection
varRanking = zeros( NTrees  , size(features,2) ) ; 

for i=1:NTrees    
   [ val ,varRanking( i , :) ]= sort( varimportance( B.Trees{i}) ,'descend')    
end 
