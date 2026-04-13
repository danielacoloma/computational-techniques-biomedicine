function [MD_recortada] = media_recortada(MD)  
    MD_zeros = isnan(MD);                      %es 1 donde MD tiene NaN (valores perdidos)
    [row, col] = find(MD_zeros);               %índices (filas y columnas) de los valores perdidos (NaN)
    media_recortada = trimmean(MD, 20);                  %calcula la media recortada al 20% para la matriz MD (descarta el 20% de los valores extremos)
    MD_recortada = MD;                         %inicializa la matriz MD_recortada como una copia de MD
    for i = 1:length(col)                      %itera sobre el número de valores perdidos
        MD_recortada(row(i), col(i)) = media_recortada(col(i));  %reemplaza el valor perdido en MD_recortada con la media recortada de la columna correspondiente
    end                                         
end                                             

