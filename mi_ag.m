function [x_opt,n_opt,fit_opt,fit_mean] = mi_ag(MD, Y, PopulationSize, PInicial, Pc, Pm, NGen, Elite)
    % [x_opt,n_opt,fit_opt,fit_mean] = mi_ag(MD, Y, size(PobInic,1),PobInic,0.8,0.01,100,2)
    % Esta función ejecuta un algoritmo genético (AG) para optimizar un conjunto
    % de parámetros. El objetivo es ajustar los modelos de datos (MD) para predecir
    % los resultados de la variable de salida Y, usando un algoritmo de selección
    % natural.

    % Como argumentos de entrada, la función de búsqueda del subconjunto óptimo de variables tendrá:
    % - La matriz de datos (MD) y el vector de targets (Y) de la base de datos de trabajo.
    % - Los parámetros configurables básicos de un algoritmo genético:
    %   o Tamaño de la población de soluciones potenciales (PopulationSize)
    %   o Población “semilla” inicial (PInicial)
    %   o Probabilidad de cruce (Pc, equivalente a porcentaje de reemplazo)
    %   o Probabilidad de mutación (Pm)
    %   o Número máximo de generaciones (NGen)

    % Como argumentos de salida, la función devolverá:
    % - x_opt: El individuo óptimo, es decir, la secuencia de bits que identifica qué variables han sido seleccionadas y cuáles no.
    % - n_opt: La dimensión del subespacio óptimo, es decir, el número de variables seleccionadas.
    % - fit_opt: El valor de ajuste/fitness óptimo.
    % - fit_mean: El valor de ajuste/fitness promedio de la población de la última generación.

    %% Definición de funciones para gráficos personalizados (PARTE OPTATIVA DE LA PRÁCTICA)
    % Definir funciones de gráficas personalizadas para el seguimiento del rendimiento del algoritmo genético.
    my_plot1 = @(options, state, flag) plotfun1(options, state, flag, NGen);  % Gráfica del “mejor” individuo y el valor de ajuste promedio de toda la población para cada generación
    my_plot2 = @(options, state, flag) plotfun2(options, state, flag);           % Gráfica del número de variables del subespacio óptimo para cada generación
    % function handle (@): no estamos ejecutando la función, sino que estamos 
    % pasando la “estructura” de la función como argumento de entrada para que 
    % sea llamada y ejecutada múltiples veces dentro de options

    %% Configuración de las opciones del algoritmo genético (GA)
    % Usamos 'optimoptions' para configurar las opciones específicas del solver genético 'ga'.
    options = optimoptions('ga', ...
        'InitialPopulationMatrix', PInicial, ...          % Matriz de la población inicial
        'CrossoverFraction', Pc, ...                      % Porcentaje de cruce
        'CrossoverFcn', @crossoversinglepoint, ...        % Función de cruce (un solo punto)
        'MutationFcn', {@mutationuniform, Pm}, ...        % Función de mutación uniforme
        'PopulationSize', PopulationSize, ...             % Tamaño de la población
        'EliteCount', Elite, ...                          % Número de individuos élite
        'PopulationType', 'bitstring', ...                % Codificación tipo cadena binaria
        'SelectionFcn', @selectionroulette, ...           % Función de selección (ruleta)
        'PlotInterval', 1, ...                            % Intervalo de actualización gráfica
        'PlotFcn', {@gaplotbestf, my_plot1, my_plot2}, ... % Funciones para graficar resultados ('gaplotbestf' es la función propia del solver ga)
        'MaxGenerations', NGen, ...                       % Número máximo de generaciones
        'MaxStallGenerations', 50, ...                    % Número máximo de generaciones sin mejora
        'MaxStallTime', Inf, ...                          % Tiempo máximo sin mejora
        'MaxTime', Inf);                                  % Tiempo máximo total

    %% Partición de los datos para entrenamiento y prueba
    % Dividimos los datos en un conjunto de entrenamiento y uno de prueba
    % mediante validación cruzada estratificada, preservando la
    % distribución de clases (es decir, que las proporciones 60%-40% se 
    % mantengan en todas las clases involucradas en el problema: pacientes
    % que reingresan (clase ‘1’) y pacientes que no reingresan (clase ‘0’)).
    % c = cvpartition(group, "Holdout", p, "Stratify", stratifyOption) devuelve un objeto c 
    % que define una partición aleatoria en un conjunto de entrenamiento y un conjunto 
    % de prueba o retención. Si especifica "Stratify" == false, cvpartition crea una partición 
    % aleatoria no estratificada. En caso contrario, la función aplica la estratificación de 
    % forma predeterminada.
    % - group: Variable de agrupación para la estratificación
    % - p: Fracción o número de observaciones en el conjunto de prueba
    c = cvpartition(Y, 'HoldOut', 0.4, 'Stratify', true); % 40% de los datos para test, por lo que 60% para train

    % idx = training(c) devuelve los índices de entrenamiento idx para un objeto cvpartition c de tipo 'holdout' o 'resubstitution'.
    % Si c.Type es 'holdout', idx especifica las observaciones del conjunto de entrenamiento.
    % Si c.Type es 'resubstitution', idx especifica todas las observaciones.
    % Ocurre igual con test
    idx_train = training(c);  % Índices para el conjunto de entrenamiento
    idx_test = test(c);       % Índices para el conjunto de prueba
    
    % Separamos los datos de entrenamiento y prueba
    MDtrain = MD(idx_train, :);  % Datos de entrenamiento
    MDtest = MD(idx_test, :);    % Datos de prueba
    Ytrain = Y(idx_train);       % Etiquetas (target) de entrenamiento
    Ytest = Y(idx_test);         % Etiquetas (target) de prueba

    %% Definición del número de variables
    nvars = size(MD, 2);  % Número de variables (nvars contendrá el número de columnas de MD)

    %% Definición de la función objetivo (fitfun)
    % Definimos la función objetivo 'fitfun', que será utilizada por el algoritmo.
    % La función MIDE EL RENDIMIENTO DEL MODELO para cada conjunto de variables.
    % Pasaremos al solver ga dicha función como argumento de entrada (primer 
    % argumento de entrada), mediante lo que en Matlab se denomina un 
    % function handle (@): no estamos ejecutando la función, sino que estamos 
    % pasando la “estructura” de la función como argumento de entrada para que 
    % sea llamada y ejecutada múltiples veces dentro del solver ga
    fitfun = @(x) mifitfun(x, MDtrain, Ytrain, MDtest, Ytest);

    %% Ejecución del algoritmo genético
    % Llamamos al solver 'ga' con la función objetivo, el número de variables y las opciones configuradas.
    [x_opt, fit_opt, ~, ~, ~, scores] = ga(fitfun, nvars, [], [], [], [], [], [], [], options);

    %% Resultados
    % x_opt: Solución óptima (mejor conjunto de variables)
    % fit_opt: Valor de la función objetivo (rendimiento) de la solución óptima
    % fit_mean: Promedio de los valores de fitness en la población final
    % n_opt: Número de variables seleccionadas (número de bits '1' en x_opt)
    fit_mean = mean(scores);  
    n_opt = sum(x_opt);   

end
