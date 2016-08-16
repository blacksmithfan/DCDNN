clear;clc;
% requires the vlFeat package
addpath(genpath('..\utility\mvcnn-master\'))

dataset_path='..\data\shape\';

dataset_dir=dir([dataset_path,'\*.off']);


des_path='..\data\synthetic_sketches\';

for i=1:length(dataset_dir)
    
    file_name = dataset_dir(i,1).name;
    
    mesh = loadMesh( fullfile(dataset_path,file_name) );

    ims = render_views(mesh);
    for j=1:length(ims)
        BW = edge(rgb2gray(ims{1,j}),'Canny');
        BW=~BW;
        BW=1-BW;
        BW = (BW == 0);
        close all
        imwrite(BW,fullfile(des_path,[file_name(1:end-4),'_',num2str(j),'.png']))
    end
end



