F_size_ratio = zeros(SET_NUM,OP_NUM);
for set_num = find(is_foreground)
    im_org = All_img_org{set_num};
    [rows0,cols0,~] = size(im_org);
    sal_org = All_fod{set_num};
    delte = 100;
    sal_org_bin = sal_org>delte;    
    for op_num = 1:OP_NUM
        im_ret = All_img_ret{set_num,op_num};   
        [rows1,cols1,~] = size(im_ret);
        XX = All_XX{set_num,op_num};YY = All_YY{set_num,op_num};        
        [XX1,YY1] = ReforumlatedMapping(im_org,XX,YY);
        size_ratio = sum(XX1(sal_org_bin)>0)/sum(sal_org_bin(:));
        F_size_ratio(set_num,op_num) = size_ratio;
    end
end