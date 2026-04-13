%la variable de agrupación es la ultima columna: los enfermos son los 1 y los sanos son los 0

function [MD_clase] = media_clase(MD)
    
    [filas, columnas] = size(MD); %nos dice el nº de filas y de columnas de la matriz
    x = MD(:, columnas); %coge todas las filas de la ultima columna 

    fila_enfermos = find(x); %busca los 1 (enfermos) y me da la fila en la que se encuentran
    MD_enfermos = MD(fila_enfermos,:); %crea una matriz de enfermos
    media_enfermos = mean(MD_enfermos, 'omitnan'); %hace la media por columnas de la matriz de enfermos omitiendo los Nan
    
    MD_enfermos_zeros = isnan(MD_enfermos); %crea una matriz con ceros y unos, siendo los unos los Nan
    [row_e, col_e] = find(MD_enfermos_zeros); %te dice la fila y la columna de cada Nan de los enfermos

    for i = 1:length(col_e) 
        MD_enfermos(row_e(i), col_e(i)) = media_enfermos(col_e(i)); %sustituye los valores Nan de las filas de los enfermos por la media correspondiente
    end
    
    MD_clase = MD; %crea una copia de MD para no sobreescribir

    MD_clase(fila_enfermos, :) = MD_enfermos; %sustituye la parte de los enfermos en la matriz original


    fila_sanos = find(~x); %busca los 0 (sanos) y me da la fila en la que se encuentran
    MD_sanos = MD(fila_sanos,:); %crea una matriz de sanos
    media_sanos = mean(MD_sanos, "omitnan"); %hace la media por columnas de la matriz de sanos omitiendo los Nan
    
    MD_sanos_zeros = isnan(MD_sanos); %crea una matriz con ceros y unos, siendo los unos los Nan
    [row_s,col_s] = find(MD_sanos_zeros); %te dice la fila y la columna de cada Nan de los sanos

    for i = 1:length(col_s)
        MD_sanos(row_s(i), col_s(i)) = media_sanos(col_s(i)); %sustituye los valores Nan de las filas de los sanos por la media correspondiente
    end
    
    MD_clase(fila_sanos, :) = MD_sanos; %sustituye la parte de los sanos en la matriz original

end
