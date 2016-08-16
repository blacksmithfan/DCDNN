clear;clc;

addpath(genpath('utility'))
load trained_model/network_train.mat




folder_path='.\compare';
folder_dir=dir(folder_path);
Recall=[1:20]/20;
colors ={'r','g','b','c','m','y','g','c','y','g','b','c','m','y'};
markers={'s','o','v','o','o','s','d','v','v','p','hexagram','s','o','v'};
for i=1:length(folder_dir)
    if strcmp(folder_dir(i,1).name,'.') || strcmp(folder_dir(i,1).name,'..')
    else
        fprintf('Loading %s\n',folder_dir(i,1).name)
        path=fullfile(folder_path,folder_dir(i,1).name,'PR_train.txt');
        PR_values=textread(path);
        Precision=PR_values(:,2)';
        plot(Recall,Precision,'LineWidth',2,'color',colors{i-2},'marker',markers{i-2});
        hold on
    end
end

load('store_results/result_PDCNN_train.mat')
plot(Recall,Precision_our,'LineWidth',1,'color',[1 .5 0],'marker','o','MarkerFaceColor', [1 .5 0],'MarkerEdgeColor',[1 .5 0]);
hold on

Precision_train=calcAvgPerf_1(P_points, C_training, length(C_training));
Recall_train=[1:20]/20;

plot(Recall_train,Precision_train,'LineWidth',1,'color','r','marker','hexagram','MarkerFaceColor','r','MarkerEdgeColor','r');


hleg1=legend({'Furuya (BF-fGALIF)', 'Furuya (CDMR (sigmaSM=0.1, alpha=0.3))','Furuya (CDMR (sigmaSM=0.1, alpha=0.6))',...
    'Furuya (CDMR (sigmaSM=0.05, alpha=0.3))','Furuya (CDMR (sigmaSM=0.05, alpha=0.6))',...
    'Li (SBR-VC (alpha=0.5))','Li (SBR-VC (alpha=1))','Tatsuma (OPHOG)','Tatsuma (SCMR-OPHOG)',...
    'Zou (BOF-JESC (FV_PCA32_Words128))','Zou (BOF-JESC (Words800VQ))','Zou (BOF-JESC (Words1000VQ))','PCDNN','DCDNN'},'fontsize',5);

xlabel('Recall'),ylabel('Precision')



fprintf('Testing Dataset Results:\nNN:%.4f, FT:%.4f, ST:%.4f, DCG:%.4f, E_av:%.4f, mAP,%.4f\n',...
    NN_av,FT_av,ST_av,dcg_av,E_av,Mean_Av_Precision)










