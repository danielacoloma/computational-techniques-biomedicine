function Acc = mifitfun(x, MDtrain, Ytrain, MDtest, Ytest)
    % Esta función EVALÚA LA PRECISIÓN DE UNA SOLUCIÓN POTENCIAL (x) dentro
    % de un algoritmo genético. Su objetivo es calcular la precisión (accuracy)
    % de un modelo de clasificación usando regresión logística binomial.
    
    % x: Vector binario que indica qué variables se seleccionan (1 = seleccionada)
    % MDtrain: Datos de entrenamiento
    % Ytrain: Etiquetas de entrenamiento
    % MDtest: Datos de prueba
    % Ytest: Etiquetas de prueba
    % Acc: Valor de ajuste negativo de la precisión (para minimización)

    %% Preprocesamiento (estandarización de los datos) 
    
    % Estandarización de los datos de entrenamiento
    % Se seleccionan solo las columnas de MDtrain donde x == 1 (variables seleccionadas)
    MDtrain1 = MDtrain(:, x == 1);
    [MDtrain_std, mu, sigma] = zscore(MDtrain1);  % Estandarizar las variables seleccionadas
    % mu = media ; sigma = desviación estándar

    % Estandarización de los datos de prueba
    % Nota: No se usa 'zscore' para los datos de prueba directamente (estandarizar las columnas 
    % de MDtest utilizando la media y desviación del conjunto de entrenamiento) porque podría 
    % haber pocos ejemplos en el conjunto de prueba, y necesitamos usar los parámetros del
    % conjunto de entrenamiento.
    MDtest1 = MDtest(:, x == 1);  % Seleccionar las mismas columnas (variables seleccionadas)
    
    % Crear una matriz vacía para almacenar los datos de prueba estandarizados
    MDtest_std = zeros(size(MDtest1));  % Inicializar la matriz de test estandarizada

    for i = 1:size(MDtest1, 2)
        MDtest_std(:, i) = (MDtest1(:, i) - mu(i)) ./ sigma(i);
    end

    %% Ajuste del modelo: Regresión logística binomial
    % Ajustamos un modelo de regresión logística a los datos de entrenamiento estandarizados.
    coefs = glmfit(MDtrain_std, Ytrain, 'binomial');  

    %% Predicción de las probabilidades en el conjunto de prueba
    % Calculamos las probabilidades predichas de pertenencia a la clase en el conjunto de prueba.
    yprob = glmval(coefs, MDtest_std, 'logit');  % Función logística
    
    % Convertir las probabilidades en clases (1 si la probabilidad >= 0.5, 0 en otro caso)
    y_class = (yprob >= 0.5) * 1;

    %% Cálculo de la precisión (Accuracy)
    % Comparamos las clases predichas con las verdaderas y calculamos la precisión.
    Acc = -1 * (sum(y_class == Ytest) / length(Ytest));  % Precisión, con signo cambiado para minimizar

    % La precisión se multiplica por -1 porque el algoritmo genético está configurado
    % para minimizar la función objetivo, pero queremos maximizar la precisión:
    % En la implementación que ha hecho Matlab® de optimización mediante algoritmos genéticos,
    % el solver ga siempre busca minimizar la función objetivo. Esto no se puede cambiar. 
    % Somos nosotros los que tenemos que adaptarnos a esta restricción. Si en nuestro problema 
    % bajo estudio necesitamos buscar un máximo (como ocurre en este caso), lo que tenemos 
    % que hacer es “engañar” al solver ga, por ejemplo, cambiando de signo el valor de fitness 
    % calculado (Acc) mediante la función objetivo (mifitfun).

end
