function [] = MKseasonal(stationvalues_index, analysisvalues,...
        Datelist, nondetect_index,maxdetect_index,...
        significancelevel,maxeventlength,seasonindex)
    
        % Function carries out seasonal Mann-Kendall and determines Theil-Sen and 
        % Akritas-Theil-Sen slopes for each season

global Xallseasons Yallseasons p p_corr Senline Nd_indallseasons Md_indallseasons Sfinal Ntotobs Nndobs Nmdobs Senline_min Senline_max Akritas_Theil_Sen_line numseas yline
%seasonindex:(1 is monthly, 2 is 4 per year (Summer, Sping, Winter, Fall), 3 is 2 per year (Winter & Sping, Summer & Fall)
    

    


Sfinal=0;
VarSfinal = 0;
VarS_corrfinal = 0;  

junk_y = analysisvalues(stationvalues_index);
    
nanind = isnan(junk_y);

Yallseasons = (junk_y(~nanind));

junk_x = Datelist(stationvalues_index);

Xallseasons = junk_x(~nanind);

Years = year(Xallseasons);

nd_ind_junk = nondetect_index(stationvalues_index);

md_ind_junk = maxdetect_index(stationvalues_index);

Nd_indallseasons = nd_ind_junk(~nanind);

Md_indallseasons = md_ind_junk(~nanind);

Ntotobs = length(Nd_indallseasons);

Nndobs = sum(Nd_indallseasons);

Nmdobs = sum(Md_indallseasons); 

switch seasonindex
    case 1
        ns = 12;
    case 2
        ns = 4;
    case 3
        ns = 2;
    case 4
        ns = numseas;
end

Senline = zeros(ns,1);
Senline_min = zeros(ns,1);
Senline_max = zeros(ns,1);

%--------------- REPEAT FOR EACH SEASON:

for season = 1:ns
    Senline_i = NaN(ns,1);
    
Slocal=0;
VarS_x1=0;
VarS_x3=0;
VarS_y1=0;
VarS_y3=0;
VarS = 0;
VarS_corr = 0;

    switch seasonindex
    case 1
        S_ind = find(month(Xallseasons)==season);
    case 2
        switch season
            case 1
                S_ind = find(or(and(month(Xallseasons)==12,day(Xallseasons)>=21),or(month(Xallseasons)==1,or(month(Xallseasons)==2,and(month(Xallseasons)==3,day(Xallseasons)<21)))));
            case 2
                S_ind = find(or(and(month(Xallseasons)==3,day(Xallseasons)>=21),or(month(Xallseasons)==4,or(month(Xallseasons)==5,and(month(Xallseasons)==6,day(Xallseasons)<21)))));
            case 3
                S_ind = find(or(and(month(Xallseasons)==6,day(Xallseasons)>=21),or(month(Xallseasons)==7,or(month(Xallseasons)==8,and(month(Xallseasons)==9,day(Xallseasons)<21)))));
            case 4
                S_ind = find(or(and(month(Xallseasons)==9,day(Xallseasons)>=21),or(month(Xallseasons)==10,or(month(Xallseasons)==11,and(month(Xallseasons)==12,day(Xallseasons)<21)))));
        end  
        
    case 3
       switch season
            case 1
                S_ind = find(or(and(month(Xallseasons)==12,day(Xallseasons)>=21),or(month(Xallseasons)==1,or(month(Xallseasons)==2,or(month(Xallseasons)==3,or( month(Xallseasons)==4, ...
                    or(month(Xallseasons)==5, and(month(Xallseasons)==6,day(Xallseasons)<21))))))));
            case 2
                S_ind = find(or(and(month(Xallseasons)==6,day(Xallseasons)>=21),or(month(Xallseasons)==7,or(month(Xallseasons)==8,or(month(Xallseasons)==9, or(month(Xallseasons)==10, ...
                    or(month(Xallseasons)==11, and(month(Xallseasons)==12,day(Xallseasons)<21))))))));
       end
    case 4
          
        getbreaks =cat(1,yline{:});
        seasonbreaks = sort(getbreaks(:,1));
        
        if season == ns
         
        S_ind = find(or(dayofyear(seasonbreaks(season))<dayofyear(Xallseasons),dayofyear(Xallseasons)<=dayofyear(seasonbreaks(1))));
         
        else
                          
        S_ind = find(and(dayofyear(seasonbreaks(season))<dayofyear(Xallseasons),dayofyear(Xallseasons)<=dayofyear(seasonbreaks(season+1))));
        
        end
               
   end

       
    Y = Yallseasons(S_ind);
    X =  Xallseasons(S_ind);
    Nd_ind = Nd_indallseasons(S_ind);
    Md_ind = Md_indallseasons(S_ind);
    
    Years_i_raw = Years(S_ind);

    xfiltered = round(X/maxeventlength)*maxeventlength;
        
    n = size(xfiltered,1);
    
    n_all(season) = n;
    
    
    if n >1;
    
    
    if seasonindex > 1
        
    %%%%%%%%%% for seasons which lap end of year: rewrite year so we have
    %%%%%%%%%% same value per season (result in tie)
    
    switch seasonindex
    case 2
        seasonend_break = datenum(1990,12,20);
    case 3
        seasonend_break = datenum(1990,12,20);
    case 4
        seasonend_break = seasonbreaks(ns);
    end
    
    ind_replaceyear = find(dayofyear(seasonend_break)<dayofyear(xfiltered));
    
    Years_i = Years_i_raw;
    
    Years_i(ind_replaceyear) = Years_i_raw(ind_replaceyear) + 1;
    
    else
    Years_i = Years_i_raw;
    end
        
    Sorted = sortrows(horzcat(Years_i,Y,Nd_ind,Md_ind),1);
    
    %Mann-Kendall:
    
        for i = 1:n-1  
    
        for j = i+1:n

    [Sij,VarS_x1ij, VarS_x3ij,VarS_y1ij, VarS_y3ij] =  man_k(Sorted,i,j);
     Slocal = Slocal + Sij;
    VarS_x1=VarS_x1 + VarS_x1ij;
    VarS_x3=VarS_x3 + VarS_x3ij;
    VarS_y1=VarS_y1 + VarS_y1ij;
    VarS_y3=VarS_y3 + VarS_y3ij;

        end
        end

    VarS = (1/18*(n*(n-1)*(2*n+5))-VarS_x1-VarS_y1)+(1/(2*n*(n-1)))*VarS_x3*VarS_y3;
    

    %%%%%%%%%Corrected for Autocorrelation:
    
        x = Sorted(:,1);
        y_repnd = Sorted(:,2);
        theil_nd = Sorted(:,3);

        theil_ndind = find(theil_nd);
        
        if ~isempty(theil_ndind)

        maxdl = max(y_repnd(theil_ndind));

        ind_replace = find(y_repnd<=maxdl);
        
        y_repnd(ind_replace) = maxdl;
        end

        I = tiedrank(y_repnd); 
        
        
    if n > 3; 
    
        [Acx,lags,Bounds]=autocorr(I,n-1);
        
        if any(isnan(Acx))
             VarS_corr = VarS;
        else
        
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
        end           
    else
        VarS_corr = VarS;
    end
        
    
   %%%%%% THEIL SEN 
   
    x = Sorted(:,1);
    y = Sorted(:,2);
    theil_nd = Sorted(:,3);

    theil_ndind = find(theil_nd);

    [N c]=size(x);
   
    Comb = combnk(1:N,2);
    
    if ~isempty(theil_ndind)
        for i = 1:1000

        y(theil_ndind) = Sorted(theil_ndind,2).*rand(size(Sorted(theil_ndind,2))); 


        if N > 2;
        deltay=diff(y(Comb),1,2);
        deltax=diff(x(Comb),1,2);
        else
        deltay=diff(y(Comb),1,1);
        deltax=diff(x(Comb),1,1);
        end

        theil_ind = find(deltax~=0);

        theil=deltay(theil_ind)./deltax(theil_ind);


        Senline_i(i)=median(theil);
        end

        Senline(season) = mean(Senline_i)/365.25;

        Senline_sorted = sort(Senline_i);
        Senline_min(season) = Senline_sorted(50)/365.25;
        Senline_max(season) = Senline_sorted(950)/365.25;
        
        
    else
        
        if N > 2;
        deltay=diff(y(Comb),1,2);
        deltax=diff(x(Comb),1,2);
        else
        deltay=diff(y(Comb),1,1);
        deltax=diff(x(Comb),1,1);
        end

        theil_ind = find(deltax~=0);

        theil=deltay(theil_ind)./deltax(theil_ind);

        Senline(season)=median(theil)/365.25;
                
        Senline_min(season) = Senline(season);
        Senline_max(season) = Senline(season);
    end

AkTheiSen = @(p) (ATS_func(p,Sorted,n));
  
  clear ATK_slopes ATK_slopes2 ATK_slopes3 ATK_slopes4 ATK_S ATK_S2 ATK_S3 ATK_S4 ind_neg ind_pos  

    ATK_slopes = (2*(min(Sorted(:,2))-max(Sorted(:,2))):(max(Sorted(:,2))-min(Sorted(:,2)))/100:2*(max(Sorted(:,2))-min(Sorted(:,2))));   % All possible slopes
    
    if sum(deltax) == 0
        
        Akritas_Theil_Sen_line(season) = NaN;
        
    elseif isempty(ATK_slopes)
        
        Akritas_Theil_Sen_line(season) = 0;
        
    else
        
        for m = 1:length(ATK_slopes)
           ATK_S(m) = AkTheiSen(ATK_slopes(m));         % S-Values corresponding to slopes
        end
    
           
                ind_neg = find(ATK_S>0,1,'last');
                ind_pos = find((ATK_S<0),1,'first');


                ATK_slopes2 = (ATK_slopes(ind_neg):(ATK_slopes(ind_pos)-ATK_slopes(ind_neg))/100:ATK_slopes(ind_pos));   
                

                   for m = 1:length(ATK_slopes2)
                        ATK_S2(m) = AkTheiSen(ATK_slopes2(m));         % S-Values corresponding to slopes
                   end

                        ind_neg = find(ATK_S2>0,1,'last');
                        ind_pos = find((ATK_S2<0),1,'first');


                        ATK_slopes3 = (ATK_slopes2(ind_neg):(ATK_slopes2(ind_pos)-ATK_slopes2(ind_neg))/100:ATK_slopes2(ind_pos));   

                       for m = 1:length(ATK_slopes3)
                            ATK_S3(m) = AkTheiSen(ATK_slopes3(m));         % S-Values corresponding to slopes
                       end


                            ind_neg = find(ATK_S3>0,1,'last');
                            ind_pos = find((ATK_S3<0),1,'first');


                           ATK_slopes4 = (ATK_slopes3(ind_neg):(ATK_slopes3(ind_pos)-ATK_slopes3(ind_neg))/100:ATK_slopes3(ind_pos));   

                           for m = 1:length(ATK_slopes4)
                                ATK_S4(m) = AkTheiSen(ATK_slopes4(m));         % S-Values corresponding to slopes
                           end

                            ind_neg = find(ATK_S4>0,1,'last');
                            ind_pos = find((ATK_S4<0),1,'first');


                           ATK_slopes5 = (ATK_slopes4(ind_neg):(ATK_slopes4(ind_pos)-ATK_slopes4(ind_neg))/100:ATK_slopes4(ind_pos));   

                           for m = 1:length(ATK_slopes5)
                                ATK_S5(m) = AkTheiSen(ATK_slopes5(m));         % S-Values corresponding to slopes
                           end

                            ind_neg = find(ATK_S5>0,1,'last');
                            ind_pos = find((ATK_S5<0),1,'first');

                            Akritas_Theil_Sen_line(season) = (ATK_slopes5(ind_neg)+ATK_slopes5(ind_pos))/(2*365.25);
                
               
   end
        

    %---------------
  
         
    else
        Senline(season) = NaN;
        Senline_min(season) = NaN;
        Senline_max(season) = NaN;
        Akritas_Theil_Sen_line(season) = NaN;
        Slocal = 0;
        VarS = 0;
        VarS_corr = 0;
    end
    
    
    
    Sfinal= Sfinal + Slocal;
    VarSfinal = VarSfinal + VarS;
    VarS_corrfinal = VarS_corrfinal + VarS_corr;  
    
   
   
end



if Sfinal > 0;
    Z = (Sfinal-1)/(VarSfinal^0.5);
elseif Sfinal == 0
    Z = 0;
else
    Z = (Sfinal+1)/(VarSfinal^0.5);
end

if Ntotobs>24
    p = 2*(1-normcdf(abs(Z),0,1));
elseif length(unique(Years))>3
    p = 2*(1-tcdf(abs(Z),round(length(Xallseasons)/ns)-1));
else
    p = NaN;
end


if Sfinal > 0;
    Z_corr = (Sfinal-1)/(VarS_corrfinal^0.5);
elseif Sfinal == 0
    Z_corr = 0;
else
    Z_corr = (Sfinal+1)/(VarS_corrfinal^0.5);
end

if Ntotobs>24
    p_corr = 2*(1-normcdf(abs(Z_corr),0,1));
else
    p_corr = NaN;
end


%For Autocorrelation plots:

    switch seasonindex
    case 1
        global I1 I2 I3 I4 I5 I6 I7 I8 I9 I10 I11 I12
                S_ind = find(month(Xallseasons)==1);
                if isempty(S_ind);
                I1 = 9999999;
                end;
        I1 = getI(S_ind,Xallseasons, Yallseasons);
                S_ind = find(month(Xallseasons)==2);
                if isempty(S_ind);
                I2 = 9999999;
                end;
        I2 = getI(S_ind,Xallseasons, Yallseasons);
                S_ind = find(month(Xallseasons)==3);
                if isempty(S_ind);
                I3 = 9999999;
                end;
        I3 = getI(S_ind,Xallseasons, Yallseasons);
                S_ind = find(month(Xallseasons)==4);
                if isempty(S_ind);
                I4 = 9999999;
                end;
        I4 = getI(S_ind,Xallseasons, Yallseasons);
                S_ind = find(month(Xallseasons)==5);
                if isempty(S_ind);
                I5 = 9999999;
                end;
        I5 = getI(S_ind,Xallseasons, Yallseasons);
                S_ind = find(month(Xallseasons)==6);
                if isempty(S_ind);
                I6 = 9999999;
                end;
        I6 = getI(S_ind,Xallseasons, Yallseasons);
                S_ind = find(month(Xallseasons)==7);
                if isempty(S_ind);
                I7 = 9999999;
                end;
        I7 = getI(S_ind,Xallseasons, Yallseasons);
                S_ind = find(month(Xallseasons)==8);
                if isempty(S_ind);
                I8 = 9999999;
                end;
        I8 = getI(S_ind,Xallseasons, Yallseasons);
                S_ind = find(month(Xallseasons)==9);
                if isempty(S_ind);
                I9 = 9999999;
                end;
        I9 = getI(S_ind,Xallseasons, Yallseasons);
                S_ind = find(month(Xallseasons)==10);
                if isempty(S_ind);
                I10 = 9999999;
                end;
        I10 = getI(S_ind,Xallseasons, Yallseasons);
                S_ind = find(month(Xallseasons)==11);
                if isempty(S_ind);
                I11 = 9999999;
                end;
        I11 = getI(S_ind,Xallseasons, Yallseasons);
                S_ind = find(month(Xallseasons)==12);
                if isempty(S_ind);
                I12 = 9999999;
                end;
        I12 = getI(S_ind,Xallseasons, Yallseasons);
           
        case 2
        global I1 I2 I3 I4 
                S_ind = find(or(and(month(Xallseasons)==12,day(Xallseasons)>=21),or(month(Xallseasons)==1,or(month(Xallseasons)==2,and(month(Xallseasons)==3,day(Xallseasons)<21)))));
                I1 = getI(S_ind,Xallseasons, Yallseasons);
                if isempty(S_ind);
                I1 = 9999999;
                end;
                S_ind = find(or(and(month(Xallseasons)==3,day(Xallseasons)>=21),or(month(Xallseasons)==4,or(month(Xallseasons)==5,and(month(Xallseasons)==6,day(Xallseasons)<21)))));
                I2 = getI(S_ind,Xallseasons, Yallseasons);
                if isempty(S_ind);
                I2 = 9999999;
                end;
                S_ind = find(or(and(month(Xallseasons)==6,day(Xallseasons)>=21),or(month(Xallseasons)==7,or(month(Xallseasons)==8,and(month(Xallseasons)==9,day(Xallseasons)<21)))));
                I3 = getI(S_ind,Xallseasons, Yallseasons);
                if isempty(S_ind);
                I3 = 9999999;
                end;
                S_ind = find(or(and(month(Xallseasons)==9,day(Xallseasons)>=21),or(month(Xallseasons)==10,or(month(Xallseasons)==11,and(month(Xallseasons)==12,day(Xallseasons)<21)))));
                I4 = getI(S_ind,Xallseasons, Yallseasons);
                if isempty(S_ind);
                I4 = 9999999;
                end;
    
        
    case 3
        global I1 I2
            
                S_ind = find(or(and(month(Xallseasons)==12,day(Xallseasons)>=21),or(month(Xallseasons)==1,or(month(Xallseasons)==2,or(month(Xallseasons)==3,or( month(Xallseasons)==4, ...
                    or(month(Xallseasons)==5, and(month(Xallseasons)==6,day(Xallseasons)<21))))))));
                I1 = getI(S_ind,Xallseasons, Yallseasons);
                if isempty(S_ind);
                I1 = 9999999;
                end;
            
                S_ind =  find(or(and(month(Xallseasons)==6,day(Xallseasons)>=21),or(month(Xallseasons)==7,or(month(Xallseasons)==8,or(month(Xallseasons)==9, or(month(Xallseasons)==10, ...
                    or(month(Xallseasons)==11, and(month(Xallseasons)==12,day(Xallseasons)<21))))))));
                I2 = getI(S_ind,Xallseasons, Yallseasons);
                if isempty(S_ind);
                I2 = 9999999;
                end;
    
    
        case 4
          global Icustomseasons
        
        for season = 1:ns
           
            if season == ns

            S_ind = find(or(dayofyear(seasonbreaks(season))<dayofyear(Xallseasons),dayofyear(Xallseasons)<=dayofyear(seasonbreaks(1))));

            else

            S_ind = find(and(dayofyear(seasonbreaks(season))<dayofyear(Xallseasons),dayofyear(Xallseasons)<=dayofyear(seasonbreaks(season+1))));

            end
            
            Icustomseasons{season} = getI(S_ind,Xallseasons, Yallseasons);
           if isempty(S_ind);
              Icustomseasons{season} = 9999999;
           end;
       
        end
    end

end


