function S = ATS_func(p,Sorted,n)

% function for Akritas-Theil-Sen slope determination: Takes input of slope
% (p), number of observations (n) as well as sorted XY data in matrix 
% 'Sorted' (dimensions: n x 3, 1st dimension X, 2nd Y and 3rd flag for non-detects) and returns S value on residuals

S=0;


Residuals = Sorted;

Residuals(:,2) = Sorted(:,2)- Residuals(:,1).*p;

for i = 1:n-1  
    
    for j = i+1:n
        
[Sij,~,~,~,~] =  man_k(Residuals,i,j);
 S = S + Sij;
    
    end
end

