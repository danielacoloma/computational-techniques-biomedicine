function [xopt,B,Se,Sp,PPV,NPV,LRmas,LRmenos,Acc] = script_examen_TCB(MD,IAH,Pob_inicial,pct)
    MD_imputada=imputacion(MD,pct)
    Y=target(IAH)
    [MDtrain,MDtest,Ytrain,Ytest]=particion(MD_imputada,Y,pctTest)
    [xopt,indices]=mi_ag(MDtrain,Ytrain,Pob_inicial)
    B=modelo(MDtrain(:,indices),Ytrain)
    [Se,Sp,PPV,NPV,LRmas,LRmenos,Acc]=evaluacion(B,MDtrain(:,indices),MDtest_std,Ytest)    
end
