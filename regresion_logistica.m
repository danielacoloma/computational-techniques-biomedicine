function [prob] = regresion_logistica(MD, umbral)
    % Asumimos que MD es la matriz de datos sin valores perdidos, con las 6 variables clínicas y la última columna como target
    [X, Y] = kvecinos(MD);
    % X = MD(:, 1:6);  % Variables independientes
    % Y = MD(:, 7);    % Variable dependiente (0: no AOS, 1: AOS) TARGET
    
    % Estandarización de las variables predictoras (tendrán media nula y varianza unidad)
    X_norm = zscore(X);
    
    %% Matriz de correlaciones entre variables independientes
    corrMatrix = corr(X_norm);
    
    % Mostrar la matriz de correlación
    disp(corrMatrix);
    
    % Eliminar variables con alta correlación (ejemplo)
    % Observando la matriz de correlacion, vemos que la variable 4 tiene alta correlación con la 6:
    X_red = X_norm(:, [1, 3, 5, 6]); %dejamos todas las filas pero quitamos columnas
    % Eliminamos la variable 4
    % La variable 2 se puede quitar tmbn tiene 0.5... con varias varible
   
    %% Nuevo modelo sin la variable correlacionada
    B_red = glmfit(X_red, Y, 'binomial');
    
    % Probabilidades predichas 
    prob = glmval(B_red, X_red, 'logit');  % Vector de probabilidades predichas
    %disp(['Probabilidad: ', num2str(prob)]) %num2str convierte numeros a texto
    
    % Cálculo de las probabilidades predichas manualmente
    % X_red_2 = [ones(length(X_red), 1) X_red]; % concatena matrices poniendo ambas ent; % concatena matrices poniendo ambas entre corchetes con un espacio entre ellas
    % z = X_red_2 * B_red;  % Combina linealmente las variables independientes con los coeficientes
    % prob_manual = 1 ./ (1 + exp(-z));  % Aplicamos la función logística
    % disp(['Probabilidad manual: ', prob_manual])
    % OJO: poner ./ para que haga la operacion elemento a elemento

    %% Inicialización de la figura
    figure;
    hold on;
    
    % Plot TN: Verdadero Negativo
    idx_TN = prob((Y == 0) & (prob < umbral)*1);
    TN = zeros(1, length(idx_TN));
    plot(TN, idx_TN, 'bs');
    hold on

    % Plot FP: Falso Positivo
    idx_FP = prob((Y == 0) & (prob >= umbral)*1);
    FP = zeros(1, length(idx_FP));
    plot(FP, idx_FP, 'rs','MarkerFaceColor','r') %MarkerFaceColor rellena el cuadrado
    hold on

    % Plot TP: Verdadero Positivo
    idx_TP = prob((Y == 1) & (prob >= umbral)*1);
    TP = ones(1, length(idx_TP));
    plot(TP, idx_TP, 'b^')
    hold on

    % Plot FN: Falso Negativo
    idx_FN = prob((Y == 1) & (prob < umbral)*1);
    FN = ones(1, length(idx_FN));
    plot(FN, idx_FN, 'r^','MarkerFaceColor','r') %MarkerFaceColor rellena el triángulo
    hold on
   
    % Línea del umbral
    plot([-0.5 1.5],[umbral umbral], 'k--')
      
    % Configuración del gráfico
    xlim([-0.5, 1.5]);
    ylim([0 1]);
    xticks([0 1]);
    xticklabels({'Clase negativa (Y = 0)', 'Clase positiva (Y = 1)'});
    ylabel('Probabilidad de pertenencia a la clase');
    legend({'TN', 'FP', 'TP', 'FN', 'umbral'}, 'Location', 'northwest');
    title('Clasificación de instancias según el modelo de regresión logística');
    hold off;

end

