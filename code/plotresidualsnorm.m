function [] = plotresidualsnorm(X,Y,PARS,Nd_ind,Md_ind) 

% Function generates probability plot for residuals of linear regression
% based on lognormal distribution of residuals. Residials are normalized by
% subtractin the expected value.

d_ind = and(~Nd_ind,~Md_ind);

res_d = Y(d_ind)- polyval(PARS(1:2),X(d_ind));


N = 100;

%--- values less than detection limit replaced with 1000 samples generated from assumed distribution:

dx = Y(Nd_ind)/(N); 
AB = repmat(dx,1,N+1);
AB(:,1) = - polyval(PARS(1:2),X(Nd_ind)) ;
Evalintervals = cumsum(AB,2); 

Intervals_RanGen = Evalintervals(:,2:101);% dimensions are # nds x 100 - representing residuals of possible non-detect values from 0 to respective detection limit

Probs = diff(normcdf(Evalintervals,0,PARS(3)),1,2);

ProbsCon = Probs./repmat(sum(Probs,2),1,100); % % conditional probabilities, given that it is known that observation is below dl: dimensions are # nds x 100


Samples = zeros(length(Y(Nd_ind)),1000);


for i=1:size(Y(Nd_ind))

Samples(i,:) = randsample(Intervals_RanGen(i,:),1000,true,ProbsCon(i,:)); % generates 1000 random values for each nd given conditional probabilities


end

%--- values greater than detection limit replaced with 1000 samples generated from assumed distribution:

dxm = PARS(3)*3.5/(N); 
ABm = repmat(dxm,[length(Y(Md_ind)),N+1]);
ABm(:,1) = Y(Md_ind)- polyval(PARS(1:2),X(Md_ind)) ;
Evalintervalsm = cumsum(ABm,2); 

Intervals_RanGenm = Evalintervalsm(:,2:101);% dimensions are # mds x 100 - representing residuals of values from reported limit to (limit + 3.5*standard deviation)

Probsm = diff(normcdf(Evalintervalsm,0,PARS(3)),1,2);

ProbsConm = Probsm./repmat(sum(Probsm,2),1,100); % % conditional probabilities, given that it is known that observation is above dl: dimensions are # nds x 100


Samplesm = zeros(length(Y(Md_ind)),1000);


for i=1:size(Y(Md_ind))

Samplesm(i,:) = randsample(Intervals_RanGenm(i,:),1000,true,ProbsConm(i,:)); % generates 1000 random values for each nd given conditional probabilities


end


%--- test goodness of fit on each of the 1000 sample sets generated:

for j = 1:1000
       
     % for each of 1000 random sets, compute goodness of fit:
    
    res_nd = Samples(:,j);  

    res_md = Samplesm(:,j); 

res = vertcat(res_d,res_nd,res_md);

if length(res)<15;
    edges = icdf('norm',[0.001,1/3,2/3,0.999],0,PARS(3));
elseif length(res)<50;
    edges = zeros(round(length(res)/5)+1,1);
    probint = edges;
    probint(1) = 0.001;
    probint(end) = 0.999;
    for p=1:length(edges)-2;
        probint(p+1) = p/round(length(res)/5);
    end
    edges = icdf('norm',probint,0,PARS(3));
else
    edges = icdf('norm',[0.001,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,0.999],0,PARS(3));
end
   [~,pall(j)]=chi2gof(res,'Edges',edges,...
        'CDF',@(z)normcdf(z,0,PARS(3)),'nparams',1,'Emin',1);


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

