function rk = get_rank( score )
%UNTITLED3 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
[rows,cols] = size(score);
rk = zeros([rows,cols]);
for r = 1:rows
    [~,I] = sort(score(r,:),'descend');
    for c = 1:cols
    rk(r,I(c)) = c;
    end
end
end

