function [resultados] = rendimiento_predictivo(MD, umbral)
    % Asumimos que MD es la matriz de datos sin valores perdidos, con las 6 variables clínicas y la última columna como target
    [~, Y] = kvecinos(MD);
    % X = MD(:, 1:6);  % Variables independientes
    % Y = MD(:, 7);    % Variable dependiente (0: no AOS, 1: AOS) TARGET
    
    %% Probabilidades predichas por el modelo de regresión logística
    prob = regresion_logistica(MD, umbral);  % Ajusta según sea necesario
    close all;  % Cierra todas las figuras abiertas
    
    %% Inicialización de variables para almacenar resultados
    resultados = table('Size', [length(umbral), 8], ...
                       'VariableTypes', repmat({'double'}, 1, 8), ...
                       'VariableNames', {'Umbral', 'Se', 'Sp', 'PPV', 'NPV', 'LR_mas', 'LR_menos', 'Acc'});
    
    %% Calcular matriz de confusión
    TP = sum((Y == 1) & (prob >= umbral)*1);  % Verdaderos positivos
    TN = sum((Y == 0) & (prob < umbral)*1);  % Verdaderos negativos
    FP = sum((Y == 0) & (prob >= umbral)*1);  % Falsos positivos
    FN = sum((Y == 1) & (prob < umbral)*1);  % Falsos negativos

    % Mostrar los valores de la matriz de confusión
    disp(['True positives (TP): ', num2str(TP)])
    disp(['True negatives (TN): ', num2str(TN)])
    disp(['False positives (FP): ', num2str(FP)])
    disp(['False negatives (FN): ', num2str(FN)])

    %% Calcular métricas de rendimiento
    Se = TP / (TP + FN);  % Sensibilidad
    Sp = TN / (TN + FP);  % Especificidad
    PPV = TP / (TP + FP); % Valor predictivo positivo
    NPV = TN / (TN + FN); % Valor predictivo negativo
    LR_mas = Se / (1 - Sp); % Razón de verosimilitud positiva
    LR_menos = (1 - Se) / Sp; % Razón de verosimilitud negativa
    Acc = (TP + TN) / (TP + TN + FP + FN); % Precisión

    % Almacenar resultados
    resultados.Umbral = umbral;
    resultados.Se = Se * 100;  % Porcentaje
    resultados.Sp = Sp * 100;  % Porcentaje
    resultados.PPV = PPV * 100;  % Porcentaje
    resultados.NPV = NPV * 100;  % Porcentaje
    resultados.LR_mas = LR_mas;
    resultados.LR_menos = LR_menos;
    resultados.Acc = Acc * 100;  % Porcentaje

    disp(resultados)

end
