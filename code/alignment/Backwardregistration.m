disp('  >>  start backward registration ...');
All_XX = cell(SET_NUM,OP_NUM);
All_YY = cell(SET_NUM,OP_NUM);
for set_num = 1:SET_NUM
    for op_num = 1:OP_NUM
        disp(['  ---+ #' num2str(op_num, '%02.0f') ' retargeted image: ' operator_name{op_num}]);        
        [foo_XX, foo_YY] = BWRegistration(All_img_org{set_num}, All_img_ret{set_num,op_num});
        All_XX{set_num,op_num} = foo_XX;
        All_YY{set_num,op_num} = foo_YY;
    end
end
