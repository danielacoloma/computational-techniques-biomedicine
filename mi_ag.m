function [xopt,indices] = mi_ag(MD,Y,Pob_inicial)
    %mi_ag(MDtrain,Ytrain,Pob_inicial)
    NGen=100;
    Pc=0.8;
    Pm=0.01;
    Elite=1;
    PopulationSize=size(Pob_inicial,1);
    Nvariables=size(MD,2);

    % Es necesario pasar al algoritmo genético la población inicial
    % especificada. Se debe pasar directamente la matriz.
    options=optimoptions('ga',...
        'InitialPopulationMatrix',Pob_inicial,...
        'CrossoverFraction',Pc,...
        'CrossoverFcn',@crossoversinglepoint,...
        'EliteCount',Elite,...
        'MaxGenerations',NGen,...
        'PopulationType','bitstring',...
        'MutationFcn',{@mutationuniform,Pm},...
        'PlotFcns',@gaplotbestf,...
        'PlotInterval',1,...
        'PopulationSize',PopulationSize,...
        'SelectionFcn',@selectionroulette,...
        'MaxStallGenerations',50,...
        'MaxStallTime',Inf,...
        'MaxTime',Inf);
    
    
    c = cvpartition(Y,'KFold',2);
    idx_test=test(c,1);
    Ment=MD(idx_test==0,:);
    Yent=Y(idx_test==0);
    Mtest=MD(idx_test==1,:);
    Ytest=Y(idx_test==1);
    [Nent,tam2]=size(Ment);
    [Ntest,tam4]=size(Mtest);
    Ment_std=zscore(Ment);
    M_mu=mean(Ment);
    M_tita=std(Ment);
    Mtest_std=(Mtest-repmat(M_mu,Ntest,1))./repmat(M_tita,Ntest,1);
    
 
    % Creación del function handle para la llamada a la función del cálculo del
    % fitness
    fFitness=@(x) fitness(x,Ment_std,Mtest_std,Yent,Ytest);

    xopt=ga(fFitness,Nvariables,[],[],[],[],[],[],[],options);
    indices=find(xopt); % indices seleccionados
end      

