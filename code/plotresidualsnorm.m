function [] = plotresidualsnorm(X,Y,PARS,Nd_ind) 

% Function generates probability plot for residuals of linear regression
% based on lognormal distribution of residuals. Residials are normalized by
% subtractin the expected value.


res_d = Y(~Nd_ind)- polyval(PARS(1:2),X(~Nd_ind));


N = 100;

dx = Y(Nd_ind)/(N); 
AB = repmat(dx,1,N+1);
AB(:,1) = - polyval(PARS(1:2),X(Nd_ind)) ;
Evalintervals = cumsum(AB,2); 

Intervals_RanGen = Evalintervals(:,2:101);% dimensions are # nds x 100 - representing incremental possible non-detect values from 0 to respective detection limit

Probs = diff(normcdf(Evalintervals,0,PARS(3)),1,2);

ProbsCon = Probs./repmat(sum(Probs,2),1,100); % % conditional probabilities, given that it is known that observation is below dl: dimensions are # nds x 100


Samples = zeros(length(Y(Nd_ind)),1000);


for i=1:size(Y(Nd_ind))

Samples(i,:) = randsample(Intervals_RanGen(i,:),1000,true,ProbsCon(i,:)); % generates 1000 random values for each nd given conditional probabilities


end

for j = 1:1000
       
     % for each of 1000 random sets, compute goodness of fit:
    
    res_nd = Samples(:,j);  


res = vertcat(res_d,res_nd);

if length(res)>15;

    [~,pall(j)]=chi2gof(res,...
        'CDF',@(z)normcdf(z,0,PARS(3)),'nparams',1,'Emin',3);

else
   
    [~,pall(j)]=chi2gof(res,'nbins',3,...
        'CDF',@(z)normcdf(z,0,PARS(3)),'nparams',1,'Emin',1);
end


if isnan(pall(j))
        [~,pall(j)]=chi2gof(res,'nbins',3,...                 % repeat if error thrown due to sparse data
        'CDF',@(z)normcdf(z,0,PARS(3)),'nparams',1,'Emin',0);
    
end

end

figure
probplot('normal',res,'noref')


ax = gca;

fun = @(z)normcdf(z,0,PARS(3));

probplot(ax,fun)




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

