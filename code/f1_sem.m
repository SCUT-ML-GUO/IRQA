F_deep_similarity = ones(SET_NUM,OP_NUM);
idx = find(is_foreground);

for i = 1:sum(is_foreground)
    fc7_org = fc7((i-1)*(OP_NUM+1)+1,:);
    for j = 1:OP_NUM
        fc7_ret = fc7((i-1)*(OP_NUM+1)+1+j,:);
        F_deep_similarity(idx(i),j) = sum(fc7_org.*fc7_ret)/norm(fc7_org)/norm(fc7_ret);
    end
end
