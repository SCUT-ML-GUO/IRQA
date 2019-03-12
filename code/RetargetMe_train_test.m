f1 = F_size_ratio;
f2 = F_deep_similarity;
feat_ars = MIT_ARS_score;
feat_egs = MIT_EGS_score;


C = 2^4.8;  gamma = 2^3.2;
idx = find(is_foreground);
obj_score = zeros(SET_NUM,OP_NUM);


for set_num = idx
    disp(['  ######## set_num = ' num2str(set_num)]);
    feat_ars_train = feat_ars(setdiff(idx,set_num),:);feat_ars_test = feat_ars(set_num,:);
    feat_egs_train = feat_egs(setdiff(idx,set_num),:);feat_egs_test = feat_egs(set_num,:);
    f1_train = f1(setdiff(idx,set_num),:);f1_test = f1(set_num,:);
    f2_train = f2(setdiff(idx,set_num),:);f2_test = f2(set_num,:);
    subj_data_train = subj_data(setdiff(idx,set_num),:);subj_data_test = subj_data(set_num,:);

    
    MIT_rankSVM_train_rbf(subj_data_train, C, gamma, ...        
        feat_ars_train,feat_egs_train,f1_train,f2_train);%
    pred_score = MIT_rankSVM_test_rbf_by_score(subj_data_test, ...        
        feat_ars_test,feat_egs_test,f1_test,f2_test);%
    obj_score(set_num, :) = pred_score;
end

obj_score(is_foreground==0,:) = feat_ars(is_foreground==0,:);
disp('--------------------------------------------')
disp('results of Dnf:')
KRCC_eval(subj_data(is_foreground==0,:), obj_score(is_foreground==0,:));
disp('--------------------------------------------')
disp('results of Df:')
KRCC_eval(subj_data(is_foreground>0,:), obj_score(is_foreground>0,:));
disp('--------------------------------------------')
disp('results of whole set:')
[mKRCC, KRCC, stdKRCC] = KRCC_eval(subj_data, obj_score);
