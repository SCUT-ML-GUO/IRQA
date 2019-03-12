function rk = get_rank( score )
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明
[rows,cols] = size(score);
rk = zeros([rows,cols]);
for r = 1:rows
    [~,I] = sort(score(r,:),'descend');
    for c = 1:cols
    rk(r,I(c)) = c;
    end
end
end

