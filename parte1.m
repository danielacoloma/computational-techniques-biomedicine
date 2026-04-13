function[nPacientes,IAH_menor_30,IAH_mayor_30,edadMediaTotal,edadMedia_IAH_menor_30,edadMedia_IAH_mayor_30,Masc_IAH_menor_30,Masc_IAH_mayor_30,IAH_medio_mayor_30]= parte1(MD,IAH)
    nPacientes = size(MD, 1);

    IAH_menor_30 = sum(IAH < 30);
    IAH_mayor_30 = sum(IAH >= 30);

    edadMediaTotal = mean(MD(:, 2));
    edadMedia_IAH_menor_30 = mean(MD(IAH < 30, 2));
    edadMedia_IAH_mayor_30 = mean(MD(IAH >= 30, 2));

    Masc_IAH_menor_30 = sum(MD(IAH < 30, 1) == 1);
    Masc_IAH_mayor_30 = sum(MD(IAH >= 30, 1) == 1);
    
    IAH_medio_mayor_30 = mean(IAH(IAH >= 30));
end
