PATH_ROOT = '..\database\RetargetMe\'; % the path direct to the MIT dataset
% load the subjective data (put the subjData at the same path)
load([PATH_ROOT 'subjData-ref_37.mat'])
subj_data = subjData.data;
SET_NUM = 37;   % 37 set images
PATH_NAME = cell(SET_NUM,1);
All_ratio = zeros(SET_NUM,1);
for set_num = 1:SET_NUM
    foo = subjData.datasetNames{set_num};
    foo_loc = strfind(foo,'_0.');
    PATH_NAME{set_num} =  foo(1:foo_loc-1);
    if(strfind(foo,'_0.75'))
        All_ratio(set_num) = 75;
    elseif(strfind(foo,'_0.50'))
        All_ratio(set_num) = 50;
    end
end
OP_NUM = 8;
operator_name = {'CR', 'SV', 'MOP', 'SC', 'SCL', 'SM', 'SNS', 'WARP'};
operator_id = {'cr', 'sv', 'multiop', 'sc.', 'scl', 'sm', 'sns', 'warp'};

smap_path = '..\pre-calculated_data\RetargetMe_Saliency_Maps\fang_smap\';
disp('  >>  start loading images ...');
All_img_org = cell(SET_NUM, 1);     
All_img_ret = cell(SET_NUM, OP_NUM);
All_smap = cell(SET_NUM, 1);        

for set_num = 1:SET_NUM
    disp(['  >> Loading #' num2str(set_num, '%03.0f') ' set --- ' PATH_NAME{set_num} '.']);
    % read the image set
    path = [PATH_ROOT PATH_NAME{set_num} '\'];
    file = dir([path,'*.png']);
    im_org = imread([path file(1).name]);
    retarget_name = zeros(OP_NUM,1);
    for i = 1:OP_NUM
        for j = 1 : size(file,1)
            k1 = strfind(file(j).name, operator_id{i});
            if(All_ratio(set_num) == 75)
                k2 = strfind(file(j).name, '_0.75');
            elseif(All_ratio(set_num) == 50)
                k2 = strfind(file(j).name, '_0.50');
            end
            if( ~isempty(k1) && ~isempty(k2))
                retarget_name(i) = j;
            end
        end
    end
    for op_num = 1:OP_NUM
        All_img_ret{set_num,op_num} = imread([path file(retarget_name(op_num)).name]);
    end
    smap = imread([smap_path PATH_NAME{set_num} '_smap.png']);
    All_img_org{set_num} = im_org;
    All_smap{set_num} = smap;
end
%gbvs
All_imp_gbvs = cell(SET_NUM,1);
parfor set_num = 1:SET_NUM
    All_imp_gbvs{set_num} = gbvs(All_img_org{set_num});
    All_imp_gbvs{set_num} = All_imp_gbvs{set_num}.master_map_resized;
end
%load foreground object detection   
All_fod = cell(SET_NUM,1);
sal_fod = zeros(1,SET_NUM);
eta = 60;
for set_num = 1:SET_NUM
        f = [ '..\pre-calculated_data\RetargetMe_Saliency_Maps\foreground_detection\' int2str(set_num) '.png'];
        fod = imread(f);
        [rows0,cols0,~] = size(All_img_org{set_num});
        All_fod{set_num} = imresize(fod,[rows0,cols0]);
        sal_fod(set_num) = mean(All_fod{set_num}(All_fod{set_num}>0));        
end
is_foreground = sal_fod>eta;

load('..\pre-calculated_data\RetargetMe_vgg16_fc7.mat')
