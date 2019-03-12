PATH_ROOT = '../database/CUHKdataset/';
load([PATH_ROOT,'session_1/session_1_MOS_Value.mat'])
load([PATH_ROOT,'session_2/session_2_MOS_Value.mat'])
SET_NUM1 = 23;
SET_NUM2 = 34;
SET_NUM = SET_NUM1+SET_NUM2;
OP_NUM = 3;
All_img_org = cell(SET_NUM1+SET_NUM2,1);
All_img_ret = cell(SET_NUM1+SET_NUM2,OP_NUM);
PATH_NAME = cell(SET_NUM1+SET_NUM2,1);

set_name1 = cell(SET_NUM1,1);
set_name2 = cell(SET_NUM2,1);
for i = 1:SET_NUM1
    p = strfind(VQ_set_1{i,1},'_');
    set_name1{i} = VQ_set_1{i,1}(1:p(end-1)-1);
    for j = 1:OP_NUM
        file_name = VQ_set_1{(j-1)*SET_NUM1+i};
        file_name(end-2:end) = 'png';     
    end
end
for i = 1:SET_NUM2
    p = strfind(VQ_set_2{i,1}{1},'_');
    set_name2{i} = VQ_set_2{i,1}{1}(1:p(end-1)-1);
    for j = 1:OP_NUM
        file_name = VQ_set_2{(j-1)*SET_NUM2+i}{1};
        file_name(end-2:end) = 'png';       
    end
end

for i = 1:SET_NUM1
    p = strfind(VQ_set_1{i,1},'_');
    PATH_NAME{i} = VQ_set_1{i,1}(1:p(end-1)-1);
    All_img_org{i} = imread([PATH_ROOT,'session_1/source_image/',set_name1{i},'.png']);
    for j = 1:OP_NUM
        file_name = VQ_set_1{(j-1)*SET_NUM1+i};
        file_name(end-2:end) = 'png';
        All_img_ret{i,j} = imread([PATH_ROOT,'session_1/retargeted_image/',file_name]);        
    end
end
for i = 1:SET_NUM2
    p = strfind(VQ_set_2{i,1}{1},'_');
    PATH_NAME{i+SET_NUM1} = VQ_set_2{i,1}{1}(1:p(end-1)-1);
    All_img_org{i+SET_NUM1} = imread([PATH_ROOT,'session_2/source_image/',set_name2{i},'.png']);
    for j = 1:OP_NUM
        file_name = VQ_set_2{(j-1)*SET_NUM2+i}{1};
        file_name(end-2:end) = 'png';
        All_img_ret{i+SET_NUM1,j} = imread([PATH_ROOT,'session_2/retargeted_image/',file_name]);        
    end
end
subj_data = zeros(SET_NUM,OP_NUM);
subj_data_std = zeros(SET_NUM,OP_NUM);
for i = 1:SET_NUM1
    for j = 1:OP_NUM
        subj_data(i,j)=VQ_set_1{(j-1)*SET_NUM1+i,2};
        subj_data_std(i,j)=VQ_set_1{(j-1)*SET_NUM1+i,3};
    end
end
for i = 1:SET_NUM2
    for j = 1:OP_NUM
        subj_data(SET_NUM1+i,j)=VQ_set_2{(j-1)*SET_NUM2+i,2};
        subj_data_std(SET_NUM1+i,j)=VQ_set_2{(j-1)*SET_NUM2+i,3};
    end
end

load('..\pre-calculated_data\CUHK_Saliency_Maps\gbvs_smap\All_imp_gbvs.mat')
smap_path = '..\pre-calculated_data\CUHK_Saliency_Maps\fang_smap\';
All_smap = cell(SET_NUM, 1);  
for set_num = 1:SET_NUM
    smap = imread([smap_path num2str(set_num) '.png']);
    All_smap{set_num} = smap;
end
%load foreground object detection   
All_fod = cell(SET_NUM,1);
sal_fod = zeros(1,SET_NUM);
eta = 60;
for set_num = 1:SET_NUM
        f = ['..\pre-calculated_data\CUHK_Saliency_Maps/foreground_detection/fod' int2str(set_num) '.png'];
        fod = imread(f);
        [rows0,cols0,~] = size(All_img_org{set_num});
        All_fod{set_num} = imresize(fod,[rows0,cols0]);
        sal_fod(set_num) = mean(All_fod{set_num}(All_fod{set_num}>0));        
end
is_foreground = sal_fod>eta;

load('..\pre-calculated_data\CUHK_vgg16_fc7.mat')