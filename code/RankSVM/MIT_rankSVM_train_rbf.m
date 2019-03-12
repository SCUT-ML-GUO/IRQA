function [] = MIT_rankSVM_train_rbf(subj_data, c, gamma,varargin)

    OUTPUT_PREC = '%0.4f';
    fid = fopen('RankSVM/tmp_train_data_rbf.dat','wt');
    [SET_NUM, OP_NUM] = size(subj_data);
    for set_num = 1:SET_NUM
        for op_num = 1:OP_NUM
            query_str = [num2str(subj_data(set_num, op_num)) ...
                ' qid:' num2str(set_num) ];
            col = 1;
            for i = 1:length(varargin)                
                if length(size(varargin{i}))==2
                    query_str = [query_str ' ' num2str(col) ':' num2str(varargin{i}(set_num, op_num), OUTPUT_PREC)];
                    col = col+1;
                elseif length(size(varargin{i}))==3
                    for j = 1:size(varargin{i},3)
                        query_str = [query_str ' ' num2str(col) ':' num2str(varargin{i}(set_num, op_num,j), OUTPUT_PREC)];
                        col = col+1;
                    end
                end
            end
            fprintf(fid, '%s\n', query_str);
        end
    end
    fclose(fid);
    cmd_learn = ['RankSVM\svm_rank_learn -v 0 -c ' num2str(c) ' -t 2 ' ...
        '-g ' num2str(gamma) ...
        ' RankSVM/tmp_train_data_rbf.dat RankSVM/tmp_model_rbf'];
    system(cmd_learn);

end

