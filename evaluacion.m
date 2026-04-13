function[Se,Sp,PPV,NPV,LRmas,LRmenos,Acc]=evaluacion(B,MDtrain,MDtest,Ytest)
    % [Se,Sp,PPV,NPV,LRmas,LRmenos,Acc]=evaluacion(B,MDtrain(:,[10 14 15 19 22]),MDtest,Ytest)    
    
    MDtest_std=estandarizar(MDtrain,MDtest)

    yprob_test=glmval(B,MDtest_std,'logit')
    yclass_test=(yprob_test>=0.5)*1

    %True positives
    TP=sum(Ytest==1 & yclass_test==1)
    %False positives
    FP=sum(Ytest==0 & yclass_test==1)
    %True negatives
    TP=sum(Ytest==0 & yclass_test==0)
    %False negatives
    TP=sum(Ytest=1 & yclass_test==0)

    Acc= mean((TP+TN)/(TP+FN+TN+FP))
    Se=mean(TP/(TP+FN))
    Sp=mean(TN/(TN+FP))
    PPV=mean(TP/(TP+FP))
    NPV=mean(TN/(TN+FN))
    LRmas=mean(Se/(1-Sp))
    LRmenos=mean((1-Se)/Sp)
end