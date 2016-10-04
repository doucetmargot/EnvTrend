function [] = plotresidualslognorm(X,Y,PARS,Nd_ind,Md_ind) 

% Function generates probability plot for residuals of linear regression
% based on lognormal distribution of residuals. Residials are normalized by
% dividing by the expected value.

d_ind = and(~Nd_ind,~Md_ind);

res_d = Y(d_ind)./(10.^(polyval(PARS(1:2),X(d_ind)))); %% Mean is forced to 1 independent of X



N = 100;

%--- values less than detection limit replaced with 1000 samples generated from assumed distribution:


dx = Y(Nd_ind)/(N); 
AB = repmat(dx,1,N+1);
AB(:,1) = 0 ;
Evalintervals = cumsum(AB,2); 

Intervals_RanGen = Evalintervals(:,2:101);% dimensions are # nds x 100 - representing residuals of possible non-detect values from 0 to respective detection limit

XNd = X(Nd_ind);
Samples = zeros(length(Y(Nd_ind)),1000);


for i=1:size(Y(Nd_ind))
   
  Probs(i,:) = diff(normcdf(log10(Evalintervals(i,:)),polyval(PARS(1:2),XNd(i)),PARS(3))); % probabilities associated with making observation @ intervals within Evalintervals, given linear regression fit
  
end
    
 if size(Y(Nd_ind)) > 0
     ProbsCon = Probs./repmat(sum(Probs,2),1,100); % conditional probabilities, given that it is known that observation is below dl: dimensions are # nds x 100
 end
  
for m=1:size(Y(Nd_ind))

Samples(m,:) = randsample(Intervals_RanGen(m,:),1000,true,ProbsCon(m,:));   % generates 1000 random values for each nd given conditional probabilities

end
    
 
%--- values greater than detection limit replaced with 1000 samples generated from assumed distribution:

V = (10.^(2.*polyval(PARS(1:2),X(Md_ind))+PARS(3)*PARS(3))).*((10.^(PARS(3)*PARS(3)))-1);
  
dxm = (V.^0.5)*3.5./N; 

ABm = repmat(dxm,1,N+1);
ABm(:,1) = Y(Md_ind);
Evalintervalsm = cumsum(ABm,2); 

Intervals_RanGenm = Evalintervalsm(:,2:101);% dimensions are # mds x 100 - representing possible values from reported limit to (limit + 3.5*standard deviation)

XMd = X(Md_ind);
Samplesm = zeros(length(Y(Md_ind)),1000);


for i=1:size(Y(Md_ind))
   
  Probsm(i,:) = diff(normcdf(log10(Evalintervalsm(i,:)),polyval(PARS(1:2),XMd(i)),PARS(3))); % probabilities associated with making observation @ intervals within Evalintervals, given linear regression fit
  
end
    
 if size(Y(Md_ind)) > 0
     ProbsConm = Probsm./repmat(sum(Probsm,2),1,100); % conditional probabilities, given that it is known that observation is above dl: dimensions are # nds x 100
 end
  
for m=1:size(Y(Md_ind))

Samplesm(m,:) = randsample(Intervals_RanGenm(m,:),1000,true,ProbsConm(m,:));   % generates 1000 random values for each nd given conditional probabilities

end

%--- test goodness of fit on each of the 1000 sample sets generated:

for j = 1:1000
    
 % for each of 1000 random sets, compute goodness of fit:
 
 
res_nd = Samples(:,j)./(10.^(polyval(PARS(1:2),X(Nd_ind))));      

res_md = Samplesm(:,j)./(10.^(polyval(PARS(1:2),X(Md_ind))));      

res = log10(vertcat(res_d,res_nd,res_md));

if length(res)>15;

    [~,pall(j)]=chi2gof(res,...
        'CDF',@(z)normcdf(z,0,PARS(3)),'nparams',1,'Emin',3);

else
    
    [~,pall(j)]=chi2gof(res,'nbins',3,...
    'CDF',@(z)normcdf(z,0,PARS(3)),'nparams',1,'Emin',1);
    
end

if isnan(pall(j))
        [~,pall(j)]=chi2gof(res,'nbins',3,...                   % repeat if error thrown due to sparse data
    'CDF',@(z)normcdf(z,0,PARS(3)),'nparams',1,'Emin',0);
end
    

end
figure 

probplot('lognormal',10.^res,'noref')


ax = gca;

fun = @(z)normcdf(log10(z),0,PARS(3));

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

