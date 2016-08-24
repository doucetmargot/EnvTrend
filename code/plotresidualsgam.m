function [] = plotresidualsgam(X,Y,PARS,Nd_ind) 

% Function generates probability plot for residuals of linear regression
% based on gamma distribution of residuals. Residials are normalized by
% dividing by the expected value.

res_d = Y(~Nd_ind)./(polyval(PARS(1:2),X(~Nd_ind))); %% Mean is forced to 1, independent of X



N = 100;

dx = Y(Nd_ind)/(N); 
AB = repmat(dx,1,N+1);
AB(:,1) = 0 ;
Evalintervals = cumsum(AB,2); 

Intervals_RanGen = Evalintervals(:,2:101);% dimensions are # nds x 100 - representing incremental possible non-detect values from 0 to respective detection limit

XNd = X(Nd_ind);
Samples = zeros(length(Y(Nd_ind)),1000);

for i=1:size(Y(Nd_ind))
   
  Probs(i,:) = diff(gamcdf(Evalintervals(i,:),1/(PARS(3)^2),(PARS(3)^2)*(PARS(1)*XNd(i)+PARS(2))));
  
 
end

 if size(Y(Nd_ind)) > 0
     ProbsCon = Probs./repmat(sum(Probs,2),1,100); % conditional probabilities, given that it is known that observation is below dl: dimensions are # nds x 100
 end
  
for m=1:size(Y(Nd_ind))

Samples(m,:) = randsample(Intervals_RanGen(m,:),1000,true,ProbsCon(m,:));  % generates 1000 random values for each nd given conditional probabilities

end


for j = 1:1000
    
     % for each of 1000 random sets, compute goodness of fit:

res_nd = Samples(:,j)./(polyval(PARS(1:2),X(Nd_ind)));

res = (vertcat(res_d,res_nd));

if length(res)>15;

    [~,pall(j)]=chi2gof(res,...
        'CDF',@(z)gamcdf(z,1/(PARS(3)^2),(PARS(3)^2)),'nparams',1,'Emin',3);
else
     [~,pall(j)]=chi2gof(res,'nbins',3,...
        'CDF',@(z)gamcdf(z,1/(PARS(3)^2),(PARS(3)^2)),'nparams',1,'Emin',1);
end

if isnan(pall(j))
         [~,pall(j)]=chi2gof(res,'nbins',3,...  % repeat if error thrown due to sparse data
        'CDF',@(z)gamcdf(z,1/(PARS(3)^2),(PARS(3)^2)),'nparams',1,'Emin',0);
end


end

fun = @(X,a,b)(gamcdf(X,a,b)); 
gampars = [1/(PARS(3)^2) (PARS(3)^2)]; 
figure 

probplot('lognormal',res,'noref');




ax = gca;


probplot(ax,fun,gampars)
title('Probability plot for Gamma distribution')


psorted = sort(pall);

pmin = psorted(50);
pmax = psorted(950);
pmed = median(psorted);

if pmed < 0.000001
 xlabel(sprintf('Fit rejected at significance < 1e-6'));   
else
xlabel(sprintf('Fit rejected at significance %#.2g (90%% CI: %#.2g - %#.2g)',pmed,pmin,pmax));
end

end


