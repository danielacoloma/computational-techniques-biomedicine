function [MD_global] = media_global(MD) 
    MD_zeros = isnan(MD); %crea una matriz con ceros y unos, siendo los unos los Nan
    [row, col] = find(MD_zeros); %te dice la fila y la columna de cada '1' (Nan)
    media_global = mean(MD, "omitnan"); %hace la media de cada columna por separado, omitiendo los Nan
    MD_global = MD; %duplica la matriz original para no sobreescribirla
    for i = 1:length(col) %bucle for que recorre toda la matriz sustituyendo los Nan por la media correspondiente a la de la columna a la que pertenecen
        MD_global(row(i), col(i)) = media_global(col(i));
    end
end

