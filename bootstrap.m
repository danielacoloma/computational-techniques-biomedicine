function [results, IC] = bootstrap(MD, B)
    % Esta función realiza un bootstrap 632 para calcular la precisión media

    % data: datos de entrada (características) de donde extraigo bootstrap
    % B: número de muestras bootstrap

    % Obtener la matriz de datos (MD) y los valores de la variable respuesta (Y)
    [X, Y] = kvecinos(MD);
    % Obtenemos así la matriz de datos con los datos perdidos imputados mediante el método
    % de imputación (KNN) construido en la práctica 1, sin eliminar ningún outlier y 
    % descartando las variables redundantes detectadas.

    % Realizar el muestreo bootstrap
    [bootstat, bootsam] = bootstrp(B, [], X); % El tercer parámetro es la población
    [row, col] = size(bootsam);
    % bootstat no se utiliza porque esta relacionado con el fun que no he usado
    % bootsam no crea las matrices, cada columna contiene los indices de
    % las filas que tengo que coger de MD para crear la matriz de
    % entrenamiento (cada columna es una iteracion), y los que no se estén usando ahí,
    % son para la de test. La matriz de entrenamiento es 143x1000.
    % bootsam contiene SIEMPRE el mismo numero de filas (143) que la matriz
    % original, por lo que la matriz de entrenamiento tiene el mismo numero
    % de filas que la matriz original
    
    % Inicializar matrices de 1 fila y B (número de muestras bootstrap) columnas 
    % para guardar los resultados de cada iteracion de bootstrap
    Se = zeros(1, B);  % Sensibilidad
    Sp = zeros(1, B);  % Especificidad
    PPV = zeros(1, B); % Valor predictivo positivo
    NPV = zeros(1, B); % Valor predictivo negativo
    LRp = zeros(1, B); % Razón de verosimilitud positiva
    LRn = zeros(1, B); % Razón de verosimilitud negativa
    Acc = zeros(1, B); % Precisión
    
    for b = 1:B     % bucle que recorre desde 1 hasta B (número de muestras bootstrap)
        idx_train = bootsam(:, b); % Indices de entrenamiento (filas bootstrap)
        % vector 143x1 que incluye los indices de las filas que contiene la matriz de
        % entrenamiento

        indices = 1:row;
        idx_test = ismember(indices, idx_train); % Identificar filas de test
        % vector logico 1xrow
        %lo que voy a ver es cuales de los indices desde 1 a row estan en
        %train
        % me devuelve un vector de 1 y 0, 1 si el indice pertenece a entrenamiento
        % y 0 si no --> necesito los ceros

        % Crear las matrices de entrenamiento y test
        MDtrain = X(idx_train, :); % Datos de entrenamiento
        MDtest = X(idx_test == 0, :); % Datos de test: se corresponde con las instancias que quedan fuera de cada muestra de bootstrap
        % coge las filas que quiero y todas las columnas

        % Estandarizar los datos de entrenamiento y aplicar a los de test
        [MDtrain_std, mu, sigma] = zscore(MDtrain); % Estandarización de la matriz de entrenamiento
        MDtest_std = zeros(size(MDtest));  % Inicializar una matriz de ceros para crear la matriz de test estandarizada
        for i = 1:size(MDtest, 2) %HAGO UN BUCLE FOR PQ LO TENGO QUE ESTANDARIZAR A MANO, POR COLUMNAS, POR ESO ES HASTA SIZE(MD_TEST,2) QUE SIGNIFICA QUE ES EN SU SEGUNDA DIMENSION (RECORRO HASTA EL NUMERO DE COLUMNAS DE MDTEST)
            MDtest_std(:, i) = (MDtest(:, i) - mu(i)) ./ sigma(i); %PONGO UN PUNTO PARA QUE LO HAGA ELEMENTO A AELEMNETO, PERO AQUI NO HAÍA FALTA PQ SIGMA Y MU YA ES UN SOLO ESCALAR 
        end
        % no puedo estandarizar la matriz MDtest normal porque podria ser solo 1
        % paciente, hay que hacerlo variable a variable con las medias y las
        % desviaciones estandar, por lo que hacemos la estandarizacion a mano
        % mediante un bucle con los estadisticos de la matriz de entrenamiento

        % Obtener las etiquetas de entrenamiento y test
        Ytrain = Y(idx_train);
        Ytest = Y(idx_test == 0);
        % calculamos los targets teniendo en cuenta solo los de las filas
        % que queremos (con los mismos indices que se han usado para crear 
        % las matrices de datos)

        % Ajuste del modelo de regresión logística
        coef = glmfit(MDtrain_std, Ytrain, 'binomial');
        % voy a utilizar los mismos coeficientes para train y para test
        % porque si utilizo los coeficientes por separado, con la muestra con
        % los que los he creado, siempre da un resultado optimista
        % POR ESO SOLO UTILIZAMOS LOS DE TRAIN TAMBIÉN PARA TRABAJAR CON Y_PROB DEL TEST, PQ TENGO QUE VER TB LA RELACIÓN QUE TIENE CON LAS MUESTRAS QUE SÍ HAN SIDO ELEGIDAS PARA EL MODELO 

        % Estimación de probabilidades
        y_prob_train = glmval(coef, MDtrain_std, 'logit');
        y_prob_test = glmval(coef, MDtest_std, 'logit');
        
        % Estimación de clases
        y_class_train = (y_prob_train >= 0.5) * 1;
        y_class_test = (y_prob_test >= 0.5) * 1;
        % umbralizamos (50%) obteniendo un vector con las clases estimadas
        % al multiplicar por 1 ya no es un vector logico
        
        % Calcular la matriz de confusión
        cm = confusionmat(Ytest, y_class_test);

        TP = cm(2, 2); % Verdaderos positivos
        TN = cm(1, 1); % Verdaderos negativos
        FP = cm(1, 2); % Falsos positivos
        FN = cm(2, 1); % Falsos negativos

        % Métricas de rendimiento
        Se(b) = TP / (TP + FN);            % Sensibilidad
        Sp(b) = TN / (TN + FP);            % Especificidad
        PPV(b) = TP / (TP + FP);           % Valor predictivo positivo
        NPV(b) = TN / (TN + FN);           % Valor predictivo negativo
        LRp(b) = Se(b) / (1 - Sp(b));      % Razón de verosimilitud positiva
        LRn(b) = (1 - Se(b)) / Sp(b);      % Razón de verosimilitud negativa
        Acc(b) = (TP + TN) / (TP + TN + FP + FN);  % Precisión

        % Método 0.632 para la métrica de precisión (Acc)
        Acc_train = sum(y_class_train == Ytrain) / length(Ytrain);
        Acc_test = sum(y_class_test == Ytest) / length(Ytest);
        % length(ytrain) siempre es row porque bootsam contiene SIEMPRE el 
        % mismo numero de filas (143) que la matriz original, pero length(ytest)
        % varia en cada iteracion de bootstrap
        Acc(b) = 0.368 * Acc_train + 0.632 * Acc_test;

    end
    
    % Resultados promedio de cada métrica
    results.Se = (1/B) * sum(Se);
    results.Sp = (1/B) * sum(Sp);
    results.PPV = (1/B) * sum(PPV);
    results.NPV = (1/B) * sum(NPV);
    results.LRp = (1/B) * sum(LRp);
    results.LRn = (1/B) * sum(LRn);
    results.Acc = (1/B) * sum(Acc);

    % Intervalos de confianza del 95% de cada métrica
    IC.Se = quantile(Se, [0.025 0.975]);
    IC.Sp = quantile(Sp, [0.025 0.975]);
    IC.PPV = quantile(PPV, [0.025 0.975]);
    IC.NPV = quantile(NPV, [0.025 0.975]);
    IC.LRp = quantile(LRp, [0.025 0.975]);
    IC.LRn = quantile(LRn, [0.025 0.975]);
    IC.Acc = quantile(Acc, [0.025 0.975]);
    %calculamos los cuantiles para poder calcular el intervalo de confianza
    
    % Histograma para la métrica de precisión (Acc)
    figure;
    histogram(Acc, 0.7:0.001:1, 'Normalization', 'probability'); % para que vaya de 0.7 a 1 con un paso de 0.001
    hold on;
    xlim([0.7, 1]); % Limitar el eje x
    ylim([0, 0.05]); % Limitar el eje y
    xlabel('Precisión (Acc)');
    ylabel('Frecuencia normalizada');
    title('Distribución Bootstrap de la Precisión (Acc)');
    % Añadir las líneas rojas para el IC95%
    xline(IC.Acc(1), 'r', 'Lower CI 95%');
    xline(IC.Acc(2), 'r', 'Upper CI 95%');
    hold off;

end

%% PARTE OPCIONAL: CÁLCULO DE INTERVALOS DE CONFIANZA UTILIZANDO DOS FUNCIONES DE MATLAB

% Se utiliza un vector de 1000 posiciones, donde el vector 'Acc' contendrá 
% 1000 valores de precisión estimada (es decir, un valor por cada iteración de bootstrap).
% La media de este vector representará el valor promedio de precisión.

% A partir de estos 1000 valores de precisión, que son nuestras estimaciones, 
% podemos calcular los intervalos de confianza.

% Para ello, se utiliza una función de MATLAB que nos permite determinar el 
% valor del cuantíl de los datos. En concreto, podemos calcular el límite 
% inferior del intervalo de confianza seleccionando el valor por debajo del cual 
% se encuentra el 2.5% de los datos (cuantil 2.5%). Del mismo modo, calculamos el 
% límite superior seleccionando el valor por debajo del cual se encuentra el 97.5% 
% de los datos (cuantil 97.5%).

% Con este vector de 1000 posiciones, podemos además crear un histograma para visualizar 
% la distribución de las precisiones estimadas, y superponer los límites superior e 
% inferior de los intervalos de confianza.
