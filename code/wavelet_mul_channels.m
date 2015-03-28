clear; clc
% WAVELET FUNCTIONS + order of wavelet
%  Daubechies: 'db1' or 'haar', 'db2', ... ,'db45'
%     Coiflets  : 'coif1', ... ,  'coif5'
%     Symlets   : 'sym2' , ... ,  'sym8', ... ,'sym45'
%     Discrete Meyer wavelet: 'dmey'
%     Biorthogonal:
%         'bior1.1', 'bior1.3' , 'bior1.5'
%         'bior2.2', 'bior2.4' , 'bior2.6', 'bior2.8'
%         'bior3.1', 'bior3.3' , 'bior3.5', 'bior3.7'
%         'bior3.9', 'bior4.4' , 'bior5.5', 'bior6.8'.
%     Reverse Biorthogonal: 
%         'rbio1.1', 'rbio1.3' , 'rbio1.5'
%         'rbio2.2', 'rbio2.4' , 'rbio2.6', 'rbio2.8'
%         'rbio3.1', 'rbio3.3' , 'rbio3.5', 'rbio3.7'
%         'rbio3.9', 'rbio4.4' , 'rbio5.5', 'rbio6.8'.
[controls_dir]=dir('C:\Users\sgarg\Documents\Data\Controls\');

waveletFunction = 'db8' ; % waveletFunction = 'db8'  'sym8' ;
kfold=5;
testeval=[];
features=[];

subj_num=1;
% For each subject
for file = controls_dir'
    if (file.name ~= '.' | file.name ~= '..')
        %reading filename from the besa saved output
        S2=load(strcat(strcat(strcat(strcat('C:\Users\sgarg\Documents\Data\Controls\',file.name),'\Matlab\control_',file.name),'_x')));
        besa_output=eval(strcat(strcat('S2.control_',file.name),'_x'));
        [rows, NumOfElectrodes]=size(besa_output);
        colstart=0;
        for j = 1:NumOfElectrodes
            %Feature computation
            feature = extract_features(besa_output,j, waveletFunction);
            [rows, cols] = size(feature);
            features(subj_num,colstart+1:colstart+cols)=feature;
            colstart = colstart+cols;
        end
        labels(subj_num,:)=1;
        subj_num=subj_num+1;
    end
end
    
[concussion_dir]=dir('C:\Users\sgarg\Documents\Data\Concussion\');
for file = concussion_dir'
    % waveletFunction = 'db8'  'sym8'
    if (file.name ~= '.' | file.name ~= '..')
        %reading filename from the besa saved output
        S1=load(strcat(strcat(strcat(strcat('C:\Users\sgarg\Documents\Data\Concussion\',file.name),'\Matlab\concussed_',file.name),'_x')));
        besa_output=eval(strcat(strcat('S1.concussed_',file.name),'_x'));
        [rows, NumOfElectrodes]=size(besa_output);
        colstart=0;
        for j = 1:NumOfElectrodes
            %Feature computation
            feature = extract_features(besa_output,j, waveletFunction);
            [rows, cols] = size(feature);
            features(subj_num,colstart+1:colstart+cols)=feature;
            colstart = colstart+cols;
        end
        labels(subj_num,:)=2;
        subj_num=subj_num+1;
    end
end

%Noramalize each feauture vector
[rows, cols]=size(features);
for i=1:cols
    mn=mean(features(:,i));
    sd=std(features(:,i));
    features(:,i)=(features(:,i)-mn)/sd;
end

%k fold cross-validation
indices = crossvalind('Kfold',labels,kfold);
for i = 1:kfold
    test = (indices == i); train = ~test;
    SVMStruct  = svmtrain (features(train,:), labels(train,:));
    out_labels  = svmclassify(SVMStruct, features(test,:));
    true_labels=labels(test,:);
    testeval = [testeval sum(abs(true_labels-out_labels))];
end

