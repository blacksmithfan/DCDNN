function [ NN_av,FT_av,ST_av,dcg_av,E_av,Mean_Av_Precision,P_points ] = RetrievalEvaluation( C_depth, simti, model_label, depth_label )

% simti(i,j) denotes query i and database j 
C=C_depth;

number_of_queries=length(C);
P_points=zeros(number_of_queries,max(C));
Av_Precision=zeros(1,number_of_queries);
NN=zeros(1,number_of_queries);
FT=zeros(1,number_of_queries);
ST=zeros(1,number_of_queries);
dcg=zeros(1,number_of_queries);
E=zeros(1,number_of_queries);



for qqq=1:number_of_queries
    
    [tempx,R] = sort(simti(qqq,:),'descend');
    
    model_label_l=model_label(R);
    
    
    G=zeros(1,size(simti,2));
    for r=1:size(simti,2)
        if model_label_l(r)==depth_label(qqq)
            G(r)=1;
        end
    end;
    
    G_sum=cumsum(G);
    
    R_points=zeros(1,C(qqq));
    for rec=1:C(qqq)
        if length(find((G_sum==rec),1))<1
            fprintf('error\n');
        end
        R_points(rec)=find((G_sum==rec),1);
    end;
    P_points(qqq,1:C(qqq))=G_sum(R_points)./R_points;
    Av_Precision(qqq)=mean(P_points(qqq,1:C(qqq)));

    NN(qqq)=G(1);
    FT(qqq)=G_sum(C(qqq))/C(qqq);
    ST(qqq)=G_sum(2*C(qqq))/C(qqq);
    P_32=G_sum(32)/32;
    R_32=G_sum(32)/C(qqq);
    
    if (P_32==0)&&(R_32==0);
        E(qqq)=0;
    else
        E(qqq)=2*P_32*R_32/(P_32+R_32);
    end;
    
    NORM_VALUE=1+sum(1./log2([2:C(qqq)]));
    dcg_i=(1./log2([2:length(R)])).*G(2:end);
    dcg_i=[G(1);dcg_i(:)];
    dcg(qqq)=sum(dcg_i)/NORM_VALUE;
end;

simti=simti';



NN_av=mean(NN);
FT_av=mean(FT);
ST_av=mean(ST);
dcg_av=mean(dcg);
E_av=mean(E);
Mean_Av_Precision=mean(Av_Precision);




end

