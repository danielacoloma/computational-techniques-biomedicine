function state = plotfun1(options, state, flag, max_gen)
    % Esta función genera una gráfica personalizada durante la ejecución
    % del algoritmo genético (GA). Se utiliza para monitorear el progreso
    % de la población en cada generación, mostrando tanto el mejor fitness
    % como el fitness promedio.

    %% Parámetros de entrada:
    % options: Estructura de opciones del GA
    % state: Estructura que contiene el estado actual del GA (incluye la población, puntuaciones, generación, etc.)
    % flag: Indicador del estado del GA (como 'init', 'iter', o 'done')
    % max_gen: Número máximo de generaciones para ajustar el eje x de la gráfica
    
    %% Obtener el número de la generación actual
    x = state.Generation;  % Número de generación actual

    %% Calcular los valores de fitness
    % `state.Score` contiene los valores de fitness de toda la población en la generación actual.
    % Estamos tratando con valores negativos (para minimizar), así que:
    % - `y_best`: El mejor valor de fitness (mínimo valor de `state.Score`)
    % - `y_mean`: El valor medio de fitness en la población actual.
    
    y_best = min(state.Score);      % Mejor fitness (el mínimo en este caso, porque estamos minimizando)
    y_mean = mean(state.Score);     % Fitness promedio en la población actual

    %% Graficar los resultados
    % Graficamos el mejor fitness (`y_best`) y el promedio (`y_mean`) en cada generación.
    % - `r*` es un punto rojo para el mejor fitness en cada generación.
    % - `b.` es un punto azul para el promedio de la población en cada generación.
    % Ambos valores se grafican en valor absoluto y en porcentaje.
    
    plot(x, abs(y_best) * 100, 'r*')  % Graficar el mejor fitness en rojo (en porcentaje)
    hold on                           % Mantener la gráfica para añadir más puntos
    plot(x, abs(y_mean) * 100, 'b.')  % Graficar el fitness promedio en azul (en porcentaje)

    %% Ajustes de la gráfica
    xlabel('Generacion')         % Etiqueta del eje x
    ylabel('Precision')          % Etiqueta del eje y (Precisión en porcentaje)
    
    % Limitar el eje x para que muestre desde 0 hasta el número máximo de generaciones (max_gen).
    xlim([0 max_gen])

    %% Notas adicionales:
    % - En cada generación, se agrega un nuevo punto a la gráfica.
    % - La función `hold on` asegura que los puntos de diferentes generaciones se mantengan en la gráfica,
    %   lo que permite visualizar el progreso a medida que el algoritmo avanza.
    % - Se necesita pasar el número máximo de generaciones (`max_gen`) como un parámetro adicional
    %   para ajustar correctamente el límite del eje x.
    
    % La variable `state` es la que devuelve la función, aunque en este caso no la modificamos.

end
