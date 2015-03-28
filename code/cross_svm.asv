function testeval = cross_svm(features, labels, kfold)
%k-fold cross-validation
indices = crossvalind('Kfold',labels,kfold);
testeval=[];
for i = 1:kfold
    test = (indices == i); train = ~test;
    SVMStruct  = svmtrain (features(train,:), labels(train,:));
    out_labels  = svmclassify(SVMStruct, features(test,:));
    true_labels=labels(test,:);
    testeval = [testeval sum(abs(true_labels-out_labels))];
end
