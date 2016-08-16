clear;clc;
addpath('../utility/')


Rd_dimension=300;


load('../data/finetuned_sketch_feature/training_fea.mat')
load('../data/finetuned_sketch_feature/testing_fea.mat')

training_sketch_fea=training_feature;
training_sketch_label=training_label;


training_sketch_fea = [training_sketch_fea;training_sketch_fea(end-90:end,:)];
training_sketch_label = [training_sketch_label;training_sketch_label(end-90:end)];

testing_sketch_fea=testing_feature;
testing_sketch_label=testing_label;


load('../data/shape_feature/3D_sift_1024.mat')

train_3D_fea=SIFT_fea;
train_3D_label=SIFT_label;

Target_temp=zeros(length(unique(train_3D_label)),Rd_dimension);
for c=1:length(unique(train_3D_label))
    Target_temp(c,:)=rand(1,Rd_dimension);
end

Target_3D=zeros(length(train_3D_label),Rd_dimension);
for c=1:length(unique(train_3D_label))
    idx=find(train_3D_label==c);
    randfev = Target_temp(c,:);
    Target_3D(idx,:)=repmat(randfev,[length(idx), 1]);
end

Target_sketch=zeros(length(training_sketch_label),Rd_dimension);
for c=1:length(unique(training_sketch_label))
    idx=find(training_sketch_label==c);
    randfev = Target_temp(c,:);
    Target_sketch(idx,:)=repmat(randfev,[length(idx), 1]);
end


network_layer = [300,300,300,300,300];


net_3D = feedforwardnet(network_layer);
net_3D.divideFcn = '';
net_3D.trainParam.epochs = 100000;
net_3D.trainParam.goal = 1e-5;
net_3D.performParam.regularization = 0.2;
net_3D.trainParam.showWindow = 0;
net_3D.trainParam.showCommandLine	= 1;
net_3D.trainParam.show = 250;


[net_3D,tr_3D] = train(net_3D,train_3D_fea',Target_3D','useGPU','yes','showResources','yes');

new_train_3D_fea = net_3D(train_3D_fea','useGPU','no','showResources','yes');



net_sketch = feedforwardnet(network_layer);
net_sketch.divideFcn = '';
net_sketch.trainParam.epochs = 100000;
net_sketch.trainParam.goal = 1e-5;
net_sketch.performParam.regularization = 0.2;
net_sketch.trainParam.showWindow = 0;
net_sketch.trainParam.showCommandLine	= 1;
net_sketch.trainParam.show = 250;

[net_sketch,tr_img] = train(net_sketch,training_sketch_fea',Target_sketch','useGPU','yes','showResources','yes');

new_training_sketch_fea = net_sketch(training_sketch_fea','useGPU','no','showResources','yes');
new_testing_sketch_fea = net_sketch(testing_sketch_fea','useGPU','no','showResources','yes');






