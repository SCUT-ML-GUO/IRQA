function [mKRCC, KRCC, stdKRCC] = ...
    KRCC_eval(subj_data, obj_score)

SET_NUM = size(obj_score,1);
KRCC = zeros(SET_NUM,1);
for set_num = 1:SET_NUM
    subj = subj_data(set_num,:);
    obj = obj_score(set_num,:);    
    KRCC(set_num) = getKLCorr(subj, obj);
    %KRCC(set_num) = getKLCorr_n(subj, obj,3);    
end
mKRCC = mean(KRCC);
stdKRCC = std(KRCC);

PREC = '%0.3f';
disp(['mean KRCC = ' num2str(mKRCC, PREC)]);
disp(['std KRCC = ' num2str(stdKRCC, PREC)]);
end

