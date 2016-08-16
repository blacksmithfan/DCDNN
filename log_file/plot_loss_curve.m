clear;clc;

fileID = fopen('lenet_train.log.train');

iter=zeros(501,1);train_loss=zeros(501,1);
for i=1:502
    tline = fgetl(fileID);
    if i>1
        B = textscan(tline, '%d %f %f %f');
        iter(i-1,1)=B{1,1};
        train_loss(i-1,1)=B{1,3};
    end
end

fclose(fileID)

train_loss=train_loss./10;
plot(iter,train_loss,'b','LineWidth',1);
hold on

fileID = fopen('lenet_train.log.test');

iter=zeros(251,1);test_loss=zeros(251,1);
for i=1:252
    tline = fgetl(fileID);
    if i>1
        B = textscan(tline, '%d %f %f %f');
        iter(i-1,1)=B{1,1};
        test_loss(i-1,1)=B{1,3};
    end
end

fclose(fileID)



plot(iter,test_loss,'r','LineWidth',2);

xlabel('Iterations')

legend({'Training loss * 1.00e-01','Testing accuracy'},'FontSize',12)
