function [] = detectar_outliers_multiv(MD)
    % MD es la matriz de datos que contiene las variables en columnas
    datos = kvecinos(MD);  % Asumo que 'kvecinos' devuelve una matriz de datos numéricos

    % Calcula la covarianza, estimacion media, distancia Mahalanobis y outliers con robustcov
    % La función robustcov permite calcular una estimación robusta de la matriz de covarianza y de la media del conjunto de datos, y proporciona las distancias de Mahalanobis robustas para cada observación. También puedes especificar el nivel de sensibilidad ajustando el parámetro que indica la fracción de outliers esperada.
    [covMat, meanVec, mahalDist, outliers] = robustcov(datos, 'OutlierFraction', 0.05); 
    
    % Gráfico de los valores de la distancia de Mahalanobis para cada instancia
    figure;

    subplot(1,2,1)
    gscatter(datos(:,3), datos(:,4), outliers, 'br', 'ox'); %variable 3 vs variable 4
    xlabel('Potencia relativa')
    ylabel('Entropía')
    legend({'No outliers','Outliers'})

    subplot(1,2,2)
    gscatter(datos(:,2), datos(:,5), outliers, 'br', 'ox'); %variable 2 vs variable 5
    title('Distancia robusta de Mahalanobis');
    xlabel('Varianza')
    ylabel('CTM')
    legend({'No outliers','Outliers'})
end
