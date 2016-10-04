function [] =  MK(stationvalues_index, analysisvalues,...
        Datelist, nondetect_index,maxdetect_index,...
        significancelevel,maxeventlength)
    
    % Function carries out Mann-Kendall, Theil-Sen and Akritas-Theil-Sen

  global X Y p p_corr Senline I Nd_ind Md_ind S Ntotobs Nndobs Nmdobs Senline_min Senline_max Akritas_Theil_Sen_line

  %PValues from Gilbert, 1987 Table A18 for n<10
  
  
 PValues = [0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5;...
0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5;...
0.3335	0.375	0.408	0.43	0.443	0.452	0.46	0.4655;...
0.167	0.271	0.325	0.36	0.386	0.406	0.4205	0.431;...
NaN	0.167	0.242	0.2975	0.3335	0.36	0.381	0.3975;...
NaN	0.1045	0.1795	0.235	0.281	0.317	0.3435	0.364;...
NaN	0.042	0.117	0.1855	0.236	0.274	0.306	0.332;...
NaN	NaN	0.0795	0.136	0.191	0.2365	0.272	0.3;...
NaN	NaN	0.042	0.102	0.155	0.199	0.238	0.271;...
NaN	NaN	0.02515	0.068	0.119	0.1685	0.2085	0.242;...
NaN	NaN	0.0083	0.048	0.0935	0.138	0.179	0.216;...
NaN	NaN	NaN	0.028	0.068	0.1135	0.1545	0.19;...
NaN	NaN	NaN	0.01815	0.0515	0.089	0.13	0.168;...
NaN	NaN	NaN	0.0083	0.035	0.0715	0.11	0.146;...
NaN	NaN	NaN	0.00485	0.025	0.054	0.09	0.127;...
NaN	NaN	NaN	0.0014	0.015	0.0425	0.075	0.108;...
NaN	NaN	NaN	NaN	0.0102	0.031	0.06	0.093;...
NaN	NaN	NaN	NaN	0.0054	0.0233	0.049	0.078;...
NaN	NaN	NaN	NaN	0.0034	0.0156	0.038	0.066;...
NaN	NaN	NaN	NaN	0.0014	0.01135	0.03	0.054;...
NaN	NaN	NaN	NaN	0.0008	0.0071	0.022	0.045;...
NaN	NaN	NaN	NaN	0.0002	0.00495	0.0172	0.036;...
NaN	NaN	NaN	NaN	NaN	0.0028	0.0124	0.0295;...
NaN	NaN	NaN	NaN	NaN	0.001835	0.00935	0.023;...
NaN	NaN	NaN	NaN	NaN	0.00087	0.0063	0.01865;...
NaN	NaN	NaN	NaN	NaN	0.00053	0.0046	0.0143;...
NaN	NaN	NaN	NaN	NaN	0.00019	0.0029	0.0113;...
NaN	NaN	NaN	NaN	NaN	0.0001075	0.00205	0.0083;...
NaN	NaN	NaN	NaN	NaN	0.000025	0.0012	0.00645;...
NaN	NaN	NaN	NaN	NaN	NaN	0.000815	0.0046;...
NaN	NaN	NaN	NaN	NaN	NaN	0.00043	0.00345;...
NaN	NaN	NaN	NaN	NaN	NaN	0.000275	0.0023;...
NaN	NaN	NaN	NaN	NaN	NaN	0.00012	0.0017;...
NaN	NaN	NaN	NaN	NaN	NaN	0.0000725	0.0011;...
NaN	NaN	NaN	NaN	NaN	NaN	0.000025	0.000785;...
NaN	NaN	NaN	NaN	NaN	NaN	0.0000139	0.00047;...
NaN	NaN	NaN	NaN	NaN	NaN	0.0000028	0.000325;...
NaN	NaN	NaN	NaN	NaN	NaN	NaN	0.00018;...
NaN	NaN	NaN	NaN	NaN	NaN	NaN	0.000119;...
NaN	NaN	NaN	NaN	NaN	NaN	NaN	0.000058;...
NaN	NaN	NaN	NaN	NaN	NaN	NaN	0.0000365;...
NaN	NaN	NaN	NaN	NaN	NaN	NaN	0.000015;...
NaN	NaN	NaN	NaN	NaN	NaN	NaN	0.0000089;...
NaN	NaN	NaN	NaN	NaN	NaN	NaN	0.0000028;...
NaN	NaN	NaN	NaN	NaN	NaN	NaN	0.00000154;...
NaN	NaN	NaN	NaN	NaN	NaN	NaN	0.00000028];
  
  
  %
  
    
S=0;
VarS_x1=0;
VarS_x3=0;
VarS_y1=0;
VarS_y3=0;
VarS = 0;
VarS_corr = 0;

junk_y = analysisvalues(stationvalues_index);
    
nanind = isnan(junk_y);

Y = (junk_y(~nanind));

junk_x = Datelist(stationvalues_index);

X = junk_x(~nanind);

nd_ind_junk = nondetect_index(stationvalues_index);

md_ind_junk = maxdetect_index(stationvalues_index);

Nd_ind = nd_ind_junk(~nanind);

Md_ind = md_ind_junk(~nanind);

Ntotobs = length(Nd_ind);

Nndobs = sum(Nd_ind);

Nmdobs = sum(Md_ind); 

xfiltered = round(X/maxeventlength)*maxeventlength;

n = size(xfiltered,1);

if n >3;

Sorted = sortrows(horzcat(xfiltered,Y,Nd_ind,Md_ind),1);

% 
% for i = 1:n-1  
%     
%     for j = i+1:n
%         
% [Sij,VarS_x1ij, VarS_x3ij,VarS_y1ij, VarS_y3ij] =  man_k(Sorted,i,j);
%  S = S + Sij;
% VarS_x1=VarS_x1 + VarS_x1ij;
% VarS_x3=VarS_x3 + VarS_x3ij;
% VarS_y1=VarS_y1 + VarS_y1ij;
% VarS_y3=VarS_y3 + VarS_y3ij;
%     
%     end
% end

[S,VarS_x1,VarS_x3,VarS_y1, VarS_y3] = man_k_faster(Sorted,n);

VarS = (1/18*(n*(n-1)*(2*n+5))-VarS_x1-VarS_y1)+(1/(2*n*(n-1)))*VarS_x3*VarS_y3;

if S > 0;
        Z = (S-1)/(VarS^0.5);
elseif S == 0
        Z = 0;
else
        Z = (S+1)/(VarS^0.5);
end

if n>10
  p = 2*(1-normcdf(abs(Z),0,1));
else
  p = 2*PValues(abs(S)+1,n-2);
end
    
%%%%%%%%%Corrected for Autocorrelation:

x = Sorted(:,1);
y_repnd = Sorted(:,2);
theil_nd = Sorted(:,3);

theil_ndind = find(theil_nd);

if ~isempty(theil_ndind)

maxdl = max(y_repnd(theil_ndind));

ind_replace = find(y_repnd <= maxdl);

y_repnd(ind_replace) = maxdl; 

end

I = tiedrank(y_repnd); 

     [Acx,~,Bounds]=autocorr(I,n-1);
     

    ros=Acx(2:end); %% Autocorrelation Ranks
    i=0; sni=0;
    for i=1:n-2
        if ros(i)<= Bounds(1) && ros(i) >= Bounds(2)
            sni=sni;
        else
            sni=sni+(n-i)*(n-i-1)*(n-i-2)*ros(i);
        end
    end
    nns=1+(2/(n*(n-1)*(n-2)))*sni;
    VarS_corr=VarS*(nns);

 
%%%%%% THEIL SEN  


[N ~]=size(x);


Comb = combnk(1:N,2);

y_repndrand = Sorted(:,2);


if ~isempty(theil_ndind)
    
    Senline_i(i) = zeros(1,100);
    
    for i = 1:100


    y_repndrand(theil_ndind) = Sorted(theil_ndind,2).*rand(size(Sorted(theil_ndind,2))); 

    deltay=diff(y_repndrand(Comb),1,2);
    deltax=diff(x(Comb),1,2);

    theil_ind = find(deltax~=0);

    theil=deltay(theil_ind)./deltax(theil_ind);
    Senline_i(i)=median(theil);

    end

    Senline = mean(Senline_i);

    Senline_sorted = sort(Senline_i);
    Senline_min = Senline_sorted(5);
    Senline_max = Senline_sorted(95);

    
else
    
    deltay=diff(y_repndrand(Comb),1,2);
    deltax=diff(x(Comb),1,2);

    theil_ind = find(deltax~=0);

    theil=deltay(theil_ind)./deltax(theil_ind);
    Senline=median(theil);

    Senline_min = Senline;
    Senline_max = Senline;
    
end
    
    
AkTheiSen = @(p) ATS_func(p,Sorted,n);


      
     
     clear ATK_slopes ATK_S 
     

 ATK_slopes = (min(theil):(max(theil)-min(theil))/100:max(theil));
 ATK_S = zeros(size(ATK_slopes));
 
  if isempty(ATK_slopes)
        
        Akritas_Theil_Sen_line = 0;
        
    else
        
                for m = 1:length(ATK_slopes)
                ATK_S(m) = AkTheiSen(ATK_slopes(m));         % S-Values corresponding to slopes
                end
    
                ind_neg = find(ATK_S>0,1,'last');
                ind_pos = find((ATK_S<0),1,'first');

              
                Akritas_Theil_Sen_line = (ATK_slopes(ind_neg)+ATK_slopes(ind_pos))/(2);
                
                if abs(Akritas_Theil_Sen_line)*365.25 >= 1e-6 ;
                
                 ATK_slopes = (ATK_slopes(ind_neg):(ATK_slopes(ind_pos)-ATK_slopes(ind_neg))/100:ATK_slopes(ind_pos));   

               for m = 1:length(ATK_slopes)
                    ATK_S(m) = AkTheiSen(ATK_slopes(m));         % S-Values corresponding to slopes
               end

            
                    ind_neg = find(ATK_S>0,1,'last');
                    ind_pos = find((ATK_S<0),1,'first');


                    Akritas_Theil_Sen_line = (ATK_slopes(ind_neg)+ATK_slopes(ind_pos))/(2);
                
                    if abs(Akritas_Theil_Sen_line)*365.25 >= 1e-6 ;
                    
                    
                   ATK_slopes = (ATK_slopes(ind_neg):(ATK_slopes(ind_pos)-ATK_slopes(ind_neg))/100:ATK_slopes(ind_pos));   

                   for m = 1:length(ATK_slopes)
                        ATK_S(m) = AkTheiSen(ATK_slopes(m));         % S-Values corresponding to slopes
                   end


                    
                        ind_neg = find(ATK_S>0,1,'last');
                        ind_pos = find((ATK_S<0),1,'first');


                        Akritas_Theil_Sen_line = (ATK_slopes(ind_neg)+ATK_slopes(ind_pos))/(2);
                
                         if abs(Akritas_Theil_Sen_line)*365.25 >= 1e-6 ;
                    
                        
                       ATK_slopes = (ATK_slopes(ind_neg):(ATK_slopes(ind_pos)-ATK_slopes(ind_neg))/100:ATK_slopes(ind_pos));   

                       for m = 1:length(ATK_slopes)
                            ATK_S(m) = AkTheiSen(ATK_slopes(m));         % S-Values corresponding to slopes
                       end

                        ind_neg = find(ATK_S>0,1,'last');
                        ind_pos = find((ATK_S<0),1,'first');
                        
                        Akritas_Theil_Sen_line = (ATK_slopes(ind_neg)+ATK_slopes(ind_pos))/(2);
                
                        if abs(Akritas_Theil_Sen_line)*365.25 >= 1e-6 ;
                           
                       ATK_slopes = (ATK_slopes(ind_neg):(ATK_slopes(ind_pos)-ATK_slopes(ind_neg))/100:ATK_slopes(ind_pos));   

                       for m = 1:length(ATK_slopes)
                            ATK_S(m) = AkTheiSen(ATK_slopes(m));         % S-Values corresponding to slopes
                       end

                        ind_neg = find(ATK_S>0,1,'last');
                        ind_pos = find((ATK_S<0),1,'first');

                        Akritas_Theil_Sen_line = (ATK_slopes(ind_neg)+ATK_slopes(ind_pos))/(2);
                        
                        end
                         end
                    end
                end
    
   end
        

    
         
else
        Senline=NaN;
        Senline_min = NaN;
        Senline_max = NaN;
        Akritas_Theil_Sen_line = NaN;
        S = 0;
        VarS = 0;
        VarS_corr = 0;
        p = NaN;
        p_corr = NaN;
end
    
    
%%%%%%%%%-------------------------

if S > 0;
        Z_corr = (S-1)/(VarS_corr^0.5);
elseif S == 0
        Z_corr = 0;
else
        Z_corr = (S+1)/(VarS_corr^0.5);
end

if n>10
  p_corr = 2*(1-normcdf(abs(Z_corr),0,1));
else 
  p_corr = NaN;
end


end

