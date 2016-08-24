function [ I ] = getI(S_ind,Xallseasons, Yallseasons)
   
    % function computes tied rank on all Y values for a specified season,
    % indicated by season index S_ind

    X =  Xallseasons(S_ind);
    Y =  Yallseasons(S_ind);


    sorted = sortrows(horzcat(X,Y),1);

    I = tiedrank(sorted(:,2)); 
  


end

