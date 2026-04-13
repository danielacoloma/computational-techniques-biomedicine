function state = plotfun2(options, state, flag)
    % Esta función genera una gráfica personalizada que muestra el número de
    % variables seleccionadas (features) por la mejor solución en cada generación
    % del algoritmo genético (GA).
    
    %% Parámetros de entrada:
    % options: Estructura de opciones del GA (no se usa aquí)
    % state: Estructura que contiene el estado actual del GA, incluyendo población y puntuaciones.
    % flag: Indicador del estado del GA (por ejemplo, 'init', 'iter', 'done').

    %% Encontrar la mejor solución de la generación actual
    % `state.Score` contiene los valores de fitness de todas las soluciones de la población.
    % `mejor`: El mejor valor de fitness (mínimo) en la generación actual.
    % `ind`: El índice de la solución con el mejor fitness.
    [mejor, ind] = min(state.Score);  % Obtener el mejor fitness y su índice

    %% Contar el número de variables seleccionadas en la mejor solución
    % `state.Population(ind, :)` devuelve la solución con el mejor fitness.
    % La solución es un vector binario donde 1 indica que la variable está seleccionada.
    % `numvars`: Número de variables seleccionadas (suma de los valores 1 en el vector).
    numvars = sum(state.Population(ind, :));  % Número de variables seleccionadas en la mejor solución

    %% Graficar el número de variables seleccionadas
    x = state.Generation;  % Número de generación actual

    % Añadir un punto en la gráfica representando el número de variables seleccionadas
    % en la mejor solución de la generación actual.
    hold on
    plot(x, numvars, 'b*')  % Graficar en azul con un punto por cada generación

    %% Ajustar los límites del eje x
    % Limitar el eje x para que vaya de 0 a 100 (generaciones).
    xlim([0 100])  % Limitar el eje x de 0 a 100 (asumiendo 100 generaciones como máximo)

end
