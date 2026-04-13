function [] = detectar_outliers_univ(MD) 
    % MD es la matriz de datos que contiene las variables en columnas
    datos = kvecinos(MD);  % Asumo que 'kvecinos' devuelve una matriz de datos numéricos
    
    % Estandarización de las variables (z-score)
    MD_estandarizado = zscore(datos);  % Estandariza todas las columnas de datos

    % Diagrama de cajas (boxplot) de las variables estandarizadas
    figure;
    variables = {'Variable 1', 'Variable 2', 'Variable 3', 'Variable 4', 'Variable 5', 'Variable 6'};
    boxplot(MD_estandarizado, variables);
    title('Diagrama de cajas para la detección de outliers (variables estandarizadas)');
    xlabel('Variables');
    ylabel('Valores estandarizados');

    % En un diagrama de cajas, los outliers suelen aparecer como puntos fuera de los "bigotes", 
    % que son líneas que se extienden desde el límite del rango intercuartílico (IQR) hasta un 
    % valor determinado por la fórmula del gráfico. 
end

