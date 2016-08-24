function [] = LR(stationvalues_index, analysisvalues,...
        Datelist, nondetect_index,maxdetect_index,...
        significancelevel);
% Function carries out linear regression based on normal, lognormal (base
% 10) and gamma distribution of residuals assumption

global Xi Yi bi PARSnormi pnormi logYi b_logi PARS_logi PARS_gami plognormi pgami Nd_indi Md_indi Ntotobs Nndobs Nmdobs

%Preprocessing: values that are not numbers are removed

junk_y = analysisvalues(stationvalues_index);

nanind = isnan(junk_y);

Y = (junk_y(~nanind)); % Y values

junk_x = Datelist(stationvalues_index);

X = junk_x(~nanind); % X Values

nd_ind = nondetect_index(stationvalues_index);

md_ind = maxdetect_index(stationvalues_index);

Nd_ind = nd_ind(~nanind); % Non-detect flags

Md_ind = md_ind(~nanind);

d_ind = and(~Nd_ind,~Md_ind);


Ntotobs = length(Nd_ind); % Number of total observations
 
Nndobs = sum(Nd_ind); % Number of non-detects

Nmdobs = sum(Md_ind); % Number of max. detects

%%%%%%%%%-------------- Normal distribution
b = polyfit(X,Y,1);   % first guess for linear fit

s = norm(Y-polyval(b,X))/sqrt(length(Y)); % first guess for std. deviation

linearnormfunc = @(p) -sum(log(normpdf(Y(d_ind),p(1)*X(d_ind)+p(2),p(3))))...
            - sum(log(  normcdf(Y(Nd_ind),p(1)*X(Nd_ind)+p(2),p(3))   - normcdf(0,p(1)*X(Nd_ind)+p(2),p(3))  ))...   
            - sum(log(  1 - normcdf(Y(Md_ind),p(1)*X(Md_ind)+p(2),p(3))  )); % log likelihood of making observations
    
        
[PARSnorm,val1] = fminsearch(linearnormfunc,[b, s],optimset('MaxFunEvals',2000)); %PARS(1) is slope, PARS(2) is intercept - log likelihood maximized (negative is minimized using fminsearch function) 

loglike_linearnorm = -val1;


%--------------- Get loglikelihood without linear model:

normfunc = @(p) -sum(log(normpdf(Y(d_ind),p(1),p(2))))...
            - sum(log(  normcdf(Y(Nd_ind),p(1),p(2))    -   normcdf(0,p(1),p(2))    ))...
             - sum(log( 1 -  normcdf(Y(Md_ind),p(1),p(2))   ));
    
        
[~,val2] = fminsearch(normfunc,[mean(Y), s],optimset('MaxFunEvals',2000));  

loglike_norm = -val2;

%-------- TEST for significance:

teststatnorm = 2*(loglike_linearnorm-loglike_norm);

pnorm = chi2cdf(teststatnorm,1,'upper');

%%%%%%%%%-------------- Lognormal distribution

logY = log10(Y);


b_log = polyfit(X,logY,1); 

s = norm(logY-polyval(b_log,X))/sqrt(length(logY));

linearlognormfunc = @(p) -sum(log(normpdf(logY(d_ind),p(1)*X(d_ind)+p(2),p(3))))...
            - sum(log(normcdf(logY(Nd_ind),p(1)*X(Nd_ind)+p(2),p(3))))...
          - sum(log(1-normcdf(logY(Md_ind),p(1)*X(Md_ind)+p(2),p(3))));
    
        
[PARS_log,val3] = fminsearch(linearlognormfunc,[b_log, s],optimset('MaxFunEvals',2000)); %PARS(1) is slope, PARS(2) is intercept

loglike_linearlognorm = -val3;


%--------------- Get loglikelihood without linear model:

lognormfunc = @(p) -sum(log(normpdf(logY(d_ind),p(1),p(2))))... %p(1) is mean, p(2) is std
            - sum(log(normcdf(logY(Nd_ind),p(1),p(2))))...
        - sum(log(1-normcdf(logY(Md_ind),p(1),p(2))));
    
        
[~,val4] = fminsearch(lognormfunc,[mean(logY), s],optimset('MaxFunEvals',2000)); 

loglike_lognorm = -val4;

%-------- TEST for significance:

teststatlognorm = 2*(loglike_linearlognorm-loglike_lognorm);

plognorm = chi2cdf(teststatlognorm,1,'upper');



%%%%%%%%%-------------- GAMMA distribution
b = polyfit(X,Y,1); 

cov = norm(Y-polyval(b,X))/(sqrt(length(Y))*mean(Y));

lineargamfunc = @(p) -sum(log(gampdf(Y(d_ind),(1./(p(3)^2)),(p(3)^2).*(p(1).*X(d_ind)+p(2)))))...
            - sum(log(gamcdf(Y(Nd_ind),(1./(p(3)^2)),(p(3)^2).*(p(1).*X(Nd_ind)+p(2)))))...
             - sum(log(1-gamcdf(Y(Md_ind),(1./(p(3)^2)),(p(3)^2).*(p(1).*X(Md_ind)+p(2)))));
              
[PARS_gam,val5] = fminsearch(lineargamfunc,[b, cov],optimset('MaxFunEvals',2000)); %PARS(1) is slope, PARS(2) is intercept PARS(3) is COV

loglike_lineargam = -val5;


%--------------- Get loglikelihood without linear model:

gamfunc = @(p) -sum(log(gampdf(Y(d_ind),p(1),p(2))))...
            - sum(log(gamcdf(Y(Nd_ind),p(1),p(2))))...
            - sum(log(1-gamcdf(Y(Md_ind),p(1),p(2))));
    
        
[~,val6] = fminsearch(gamfunc,[1/(cov^2), (cov^2)*(mean(Y))],optimset('MaxFunEvals',2000));  %p(1) is shape parameter, p(2) is scale parameter

loglike_gam = -val6;

%-------- TEST for significance:

teststatgam = 2*(loglike_lineargam-loglike_gam);

pgam = chi2cdf(teststatgam,1,'upper');
   
Xi = X;
Yi = Y;
bi = b;
PARSnormi = PARSnorm;
pnormi = pnorm;
logYi = logY;
b_logi = b_log;
PARS_logi = PARS_log; 
PARS_gami = PARS_gam;
plognormi = plognorm;
pgami = pgam;
Nd_indi  = Nd_ind;
Md_indi  = Md_ind;

if Ntotobs < 3 
    
PARSnormi = NaN;
pnormi = NaN;
PARS_logi = NaN;
PARS_gami = NaN;
plognormi = NaN;
pgami = NaN;
end

end

