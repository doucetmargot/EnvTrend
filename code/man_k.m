    function [S,VarS_x1,VarS_x3,VarS_y1, VarS_y3] = man_k(XY,i,j)

    %Function computes S and Var statistics for the pair ij in the data set
    %XY
    
S=0;
VarS_x1=0;
VarS_x3=0;
VarS_y1=0;
VarS_y3=0;
 
    
    
    if XY(i,1)==XY(j,1)
        S=0;
        VarS_x1 = 18;
        VarS_x3 = 2;
    else
        
        if  and(XY(i,2)<XY(j,2),and(XY(j,3)== 0,XY(i,4)== 0));
            S = 1;
            
        elseif  and(XY(i,2)<XY(j,2),and(XY(j,3)== 0,XY(i,4)== 1));
            S = 0;
            VarS_y1 = 18;
            VarS_y3 = 2;
            
        elseif  and(XY(i,2)>XY(j,2),XY(i,3)== 0);
            if XY(j,4)== 0
                S=-1;
            else
                S=0;
                VarS_y1 = 18;
                VarS_y3 = 2;
            end
            
        elseif and(XY(i,2)==XY(j,2),and(XY(i,3)== 1,XY(j,3)== 0));
            S=1;
            
        elseif and(XY(i,2)==XY(j,2),and(XY(i,3)== 0,XY(j,3)== 1));
            S=-1;
                        
        elseif and(XY(i,2)==XY(j,2),and(XY(i,4)== 1,XY(j,4)== 0));
            S=-1;
            
        elseif and(XY(i,2)==XY(j,2),and(XY(i,4)== 0,XY(j,4)== 1));
            S=1;
                        
        else
            S=0;
            VarS_y1 = 18;
            VarS_y3 = 2;
        end
    end
end

