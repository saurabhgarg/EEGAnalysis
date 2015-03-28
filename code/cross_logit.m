function testeval = cross_logit(features, labels, kfold)
%k-fold cross-validation
indices = crossvalind('Kfold',labels,kfold);
testeval=[];
for i = 1:kfold
    test = (indices == i); train = ~test;
    [b,dev,stats] = glmfit(features(train,:), labels(train), 'binomial', 'link', 'logit');
    out_labels  = glmval(b,features(test,:),'logit');
    true_labels=labels(test,:);
    testeval = [testeval sum(abs(true_labels-out_labels))];
end
