function Acc = fitness(x,Mtrain,Mtest,Ytrain,Ytest)

    Mtrain=Mtrain(:,x==1);
    Mtest=Mtest(:,x==1);
    
    % Creamos el modelo de regresión logística
    b=glmfit(Mtrain,Ytrain,'binomial');
    
    % Una vez que tenemos el modelo RL (es decir sus coeficientes)
    % aplicamos el modelo y clasificamos la matriz de datos de test
    y_prob=glmval(b,Mtest,'logit');
    
    y_class=(y_prob>=0.5)*1;
    
    Acc=-1*sum(y_class==Ytest)/length(Ytest);
    


