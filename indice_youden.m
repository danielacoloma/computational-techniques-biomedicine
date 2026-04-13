function [umbral_optimo, J_optimo] = indice_youden(MD)
    % X y Y son las variables independientes y la variable objetivo (target)
    [~, Y] = kvecinos(MD);

    % Inicializar variables
    umbrales = linspace(0, 1, 100);  % Umbrales de 0 a 1 con 100 pasos
    J_values = zeros(length(umbrales), 1);  % Para almacenar los valores de Youden

    % Recorrer cada umbral para calcular sensibilidad y especificidad
    for i = 1:length(umbrales)
        umbral = umbrales(i);
        
        % Obtener probabilidades predichas por el modelo de regresión logística
        prob = regresion_logistica(MD, umbral);
        
        % Binarizar predicciones usando el umbral actual
        pred = prob >= umbral;
        
        % Calcular matriz de confusión
        TP = sum((Y == 1) & (pred == 1));  % Verdaderos positivos
        TN = sum((Y == 0) & (pred == 0));  % Verdaderos negativos
        FP = sum((Y == 0) & (pred == 1));  % Falsos positivos
        FN = sum((Y == 1) & (pred == 0));  % Falsos negativos
        
        % Calcular sensibilidad (Se) y especificidad (Sp)
        Se = TP / (TP + FN);  % Sensibilidad
        Sp = TN / (TN + FP);  % Especificidad
        
        % Calcular índice de Youden (J)
        J_values(i) = Se + Sp - 1;
    end

    % Encontrar el umbral que maximiza el índice de Youden
    [J_optimo, idx_optimo] = max(J_values);
    umbral_optimo = umbrales(idx_optimo);
    
    % Mostrar los resultados
    disp(['El umbral óptimo es: ', num2str(umbral_optimo)]);
    disp(['El índice de Youden máximo es: ', num2str(J_optimo)]);
    
    % Gráfica del índice de Youden frente a los umbrales
    figure;
    plot(umbrales, J_values, '-o');
    xlabel('Umbral');
    ylabel('Índice de Youden');
    title('Índice de Youden vs Umbral');
    grid on;
    
end
