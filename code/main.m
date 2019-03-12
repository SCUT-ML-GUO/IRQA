clear all; 
tic
%%
test_set = 'RetargetMe';
%test_set = 'CUHK';
%% path and other initial information
addpath('Utilities\')
addpath('alignment\')
EDGEBOX_PATH = 'EdgeGroup\';
DT_PATH = 'DT\';

%% load images,saliency maps,foreground detections
if strcmp(test_set,'RetargetMe')
    addpath('RankSVM\');
    RetargetMe_load
elseif strcmp(test_set,'CUHK')
    CUHK_load
else
    error('database setting incorrect!')
end
%% backward registration
%Backwardregistration
load(['..\pre-calculated_data\' test_set '_All_XX.mat']);
load(['..\pre-calculated_data\' test_set '_All_YY.mat']);
%% feature generation
f1_sem
f2_size
f3_ars
%f4_egs
load(['..\pre-calculated_data\' test_set '_EGS_score.mat'])
%% LOOCV with SVM rank
if strcmp(test_set,'RetargetMe')
    RetargetMe_train_test
elseif strcmp(test_set,'CUHK')
    PREC = '%0.3f';
    idx_fod = find(is_foreground);
    C = -1.2;  gamma = 0.8;
    X = [MIT_ARS_score(:),MIT_EGS_score(:),F_deep_similarity(:),F_size_ratio(:)];%
    CUHK_train_test
    fod_result = [mPLCC,mSRCC,mRMSE,mOR];
    idx_fod = find(~is_foreground);
    C = 4.2;  gamma = 2.7;
    X = [MIT_ARS_score(:),MIT_EGS_score(:)];
    CUHK_train_test
    nfod_result = [mPLCC,mSRCC,mRMSE,mOR];
    disp('--------------------------------------------')
    disp('results of Df')
    disp(['PLCC:' num2str(fod_result(1),PREC)])
    disp(['SRCC:' num2str(fod_result(2),PREC)])
    disp(['RMSE:' num2str(fod_result(3),PREC)])
    disp(['OR:  ' num2str(fod_result(4),PREC)])
    disp('--------------------------------------------')
    disp('results of Dnf')
    disp(['PLCC:' num2str(nfod_result(1),PREC)])
    disp(['SRCC:' num2str(nfod_result(2),PREC)])
    disp(['RMSE:' num2str(nfod_result(3),PREC)])
    disp(['OR:  ' num2str(nfod_result(4),PREC)])
end

toc

