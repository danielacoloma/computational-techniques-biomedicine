function[MD_imputada]=imputacion(MD,pct)
    %[MD_imputada]=imputacion(MD,5) %porque tiene que ser un porcentaje del 5% 
    
    [row,col]=size(MD);
    media=trimmean(MD,pct);
    MD_imputada=MD;
    for i= 1:col
        idx=find(isnan(MD(:,i)));
        MD_imputada(idx,i)= media(i);
    end

    % PARA RESPONDER A LAS PREGUNTAS:
    num_valores_perdidos= length(find(isnan(MD)));
    [fil,column]=find(isnan(MD));

end