function [B] = modelo(MD,Y)
    %function[B]=modelo(MDtrain(:,[10 14 15 19 22]),Ytrain)
    %seleccionando solo las variables de xopt

    MD_std = zscore(MD);

    %coeficientes del modelo
    B = glmfit(MD_std,Y,'binomial')
end