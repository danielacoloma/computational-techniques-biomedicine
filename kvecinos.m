function [MD_kvecinos, Y] = kvecinos(MD)

    Y = MD(:, 7); %ultima columna (target)
    MD_kvecinos = MD(:, 1:6); %columnas de la 1 a la 6

    MD_zeros = isnan(MD_kvecinos); %crea una matriz con ceros y unos, siendo los unos los Nan
    [row, col] = find(MD_zeros); %te dice la fila y la columna de cada Nan
    
    column = 1:6;  %crea un vector con los números de las columnas de 1 a 6, que serán utilizadas para buscar vecinos
    k = 5;  %define el número de vecinos a considerar como 5 (en el algoritmo K-vecinos más cercanos)
    
    for i = 1:length(row)  %inicia un bucle que itera sobre cada valor perdido en la matriz (NaN)
        idx = knnsearch(MD(:, column~=col(i)),MD(row(i), column~=col(i)),'k', k+1);  
        % Usa la función 'knnsearch' para buscar los k+1 vecinos más cercanos.
        % idx nos da los indices de las filas de los k=5 vecinos mas cercanos
        % 'MD(:, column~=col(i))' selecciona todas las columnas excepto la que tiene el NaN actual (col(i)).
        % 'MD(row(i), column~=col(i))' selecciona las características de la fila que contiene el NaN, excluyendo la columna con NaN.
        % 'k+1' se usa para evitar que la fila que tiene el NaN sea considerada en el grupo de vecinos más cercanos, ya que podría estar incluida en su propia búsqueda.
    
        MD_kvecinos(idx, :);  %recupera las filas de los vecinos más cercanos según los índices obtenidos (idx)
    
        media = mean(MD_kvecinos(idx, col(i)), 'omitnan');  
        % Calcula la media de los valores de los vecinos más cercanos en la columna que contiene el NaN (col(i)).
        % La opción 'omitnan' asegura que se ignoren los NaN presentes entre los vecinos.
    
        MD_kvecinos(row(i), col(i)) = media;  
        % Sustituye el valor NaN en la matriz MD_kvecinos por la media calculada de los vecinos más cercanos

    end

end
