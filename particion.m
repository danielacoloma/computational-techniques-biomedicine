function[MDtrain,MDtest,Ytrain,Ytest]=particion(MD,Y,pctTest)
    %[MDtrain,MDtest,Ytrain,Ytest]=particion(MD_imputada,Y,0.3)    

    %dividimos en dos clases (entrenamiento y test):
    c=cvpartition(Y,"Holdout",pctTest,"Stratify",true); %pctTest es 0.3 (30%)
    idx_train=training(c);
    idx_test=test(c);
    MDtrain=MD(idx_train,:);
    MDtest=MD(idx_test,:);
    Ytrain=Y(idx_train);
    Ytest=Y(idx_test);
    
    % Para rellenar la tabla:
    train_total=Ytrain
    test_total=Ytest
    train0=Ytrain(Ytrain == 0, :);
    test0=Ytest(Ytest == 0, :);
    train1=Ytrain(Ytrain == 1, :);
    test1=Ytest(Ytest ==1, :);
end