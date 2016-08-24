function [Y_slope] = linefromsens(X,Y,TheilSen)

    % Function for plotting line in middle of X and Y values given a slope (Theil-Sen)
    
     mid_Y = mean(Y);
     
     mid_X = mean(X);
        
        
       Y_slope = mid_Y - TheilSen.*(mid_X-X);
                        

end

