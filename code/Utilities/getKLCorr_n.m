function rs = getKLCorr_n(subj, obj,n)
% Kendall tau rank correlation coefficient
[mt1x, idx1] = sort(subj, 'descend'); 
[mt2x, idx2] = sort(obj, 'descend');

% find the rank
for k=1:length(subj)
    mt1x(idx1(k))=k;
    mt2x(idx2(k))=k;
end
rank1 = mt1x;
rank2 = mt2x;

len1 = length(rank1);

pass_ct = 0;
fail_ct = 0;
total_ct = 0;
for i=1:len1
    for j=i+1:len1
        if (rank1(i)<=n||rank1(j)<=n)%&&(rank2(i)<=n||rank2(j)<=n)            
            if (rank1(i)>=rank1(j) && rank2(i)>=rank2(j)) || (rank1(i)<=rank1(j) && rank2(i)<=rank2(j))
                pass_ct = pass_ct + 1;
            else
                fail_ct = fail_ct + 1;
            end
            total_ct = total_ct + 1;
        end
    end
end

rs = (pass_ct-fail_ct) / total_ct;