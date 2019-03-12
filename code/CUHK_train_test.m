

Y0 = subj_data(:);
Y = subj_data(:)/100;
Y_std = subj_data_std(:);

func_o2s = inline('beta(1)*(0.5-1./(1+exp(beta(2)*(x-beta(3)))))+beta(4)*x+beta(5)','beta','x');
rand('seed',2018)
OUT_SET = zeros(SET_NUM*OP_NUM,1);
LOOP_TIMES = 1000;
fold_set_all = zeros(LOOP_TIMES,length(idx_fod));
for i = 1:LOOP_TIMES
    fold_set_all(i,:) = randsample(idx_fod,length(idx_fod));
end



%C = 4.2;  gamma = 2.7;
dc = 0;
dgamma = 0;


obj_score = zeros(length(idx_fod)*OP_NUM,1);


beta_all = zeros(LOOP_TIMES,5);
PLCC = cell(length(dc),length(dgamma));
SRCC = cell(length(dc),length(dgamma));
RMSE = cell(length(dc),length(dgamma));
OR = cell(length(dc),length(dgamma));
for u = 1:length(dc)
        for v = 1:length(dgamma)
PLCC{u,v} = zeros(1,LOOP_TIMES);
SRCC{u,v} = zeros(1,LOOP_TIMES);
RMSE{u,v} = zeros(1,LOOP_TIMES);
OR{u,v} = zeros(1,LOOP_TIMES);
        end
end

for i = 1:LOOP_TIMES
    fold_set = fold_set_all(i,:);
    fold_num = 5;
    pos = (length(idx_fod)/fold_num)*(0:fold_num);
    pos = round(pos);
    for u = 1:length(dc)
        for v = 1:length(dgamma)
            %rand('seed',2018)
            
    for j = 1:fold_num
        fold = fold_set(pos(j)+1:pos(j+1));
        train_set0 = setdiff(idx_fod,fold);
        test_set0 = fold;
        train_set = [];
        test_set = [];
        for k = 1:OP_NUM
            train_set = [train_set,train_set0+(k-1)*SET_NUM];
            test_set = [test_set,test_set0+(k-1)*SET_NUM];
        end        
        X_train = X(train_set,:); Y_train = Y(train_set,:);
        X_test = X(test_set,:); Y_test = Y(test_set,:);
        svr = svmtrain(Y_train,X_train,['-s 3 -t 2 -c ' num2str(2^(C+dc(u))) ' -g ' num2str(2^(gamma+dgamma(v)))]);
        predicted_label = svmpredict(Y_test,X_test,svr);
        obj_score(test_set) = predicted_label*100;
    end
    idx_fod_op = [train_set,test_set];
    beta = nlinfit(obj_score(idx_fod_op),Y0(idx_fod_op),func_o2s,[10,0,40,1,0]);
    beta_all(i,:) = beta;
    mapped_score = func_o2s(beta,obj_score(idx_fod_op));
    PLCC{u,v}(i) = corr(mapped_score,Y0(idx_fod_op));
    SRCC{u,v}(i) = corr(mapped_score,Y0(idx_fod_op) , 'type' , 'Spearman');
    RMSE{u,v}(i) = sqrt(mean((mapped_score-Y0(idx_fod_op)).^2));
    is_out = abs(mapped_score-Y0(idx_fod_op))>2*Y_std(idx_fod_op);
    OUT_SET(idx_fod_op) = OUT_SET(idx_fod_op)+is_out;
    OR{u,v}(i) = mean(is_out);
        end
    end
end
% mPLCC = zeros(length(dc),length(dgamma));
% mSRCC = zeros(length(dc),length(dgamma));
% mRMSE = zeros(length(dc),length(dgamma));
% mOR = zeros(length(dc),length(dgamma));

for u = 1:length(dc)
        for v = 1:length(dgamma)
mPLCC(u,v) = median(PLCC{u,v});
mSRCC(u,v) = median(SRCC{u,v});
mRMSE(u,v) = median(RMSE{u,v});
mOR(u,v) = median(OR{u,v});
        end
end
% mPLCC(ai) = median(PLCC{1,1});
% mSRCC(ai) = median(SRCC{1,1});
% mRMSE(ai) = median(RMSE{1,1});
% mOR(ai) = median(OR{1,1});