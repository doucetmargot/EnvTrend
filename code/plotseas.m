function [Xseas, Yseas,Nd_indseas,Md_indseas] = plotseas(season,X,Y,Nd_ind,Md_ind)


% function takes all X and Y values as well as selected season data and
% returns y and x values which belong to selected season

global seasonindex yline

   switch seasonindex
    case 1
        S_ind = find(month(X)==season);
    case 2
        switch season
            case 1
                S_ind = find(or(and(month(X)==12,day(X)>=21),or(month(X)==1,or(month(X)==2,and(month(X)==3,day(X)<21)))));
            case 2
                S_ind = find(or(and(month(X)==3,day(X)>=21),or(month(X)==4,or(month(X)==5,and(month(X)==6,day(X)<21)))));
            case 3
                S_ind = find(or(and(month(X)==6,day(X)>=21),or(month(X)==7,or(month(X)==8,and(month(X)==9,day(X)<21)))));
            case 4
                S_ind = find(or(and(month(X)==9,day(X)>=21),or(month(X)==10,or(month(X)==11,and(month(X)==12,day(X)<21)))));
        end  
        
    case 3
       switch season
            case 1
                S_ind = find(or(and(month(X)==12,day(X)>=21),or(month(X)==1,or(month(X)==2,or(month(X)==3,or( month(X)==4, ...
                    or(month(X)==5, and(month(X)==6,day(X)<21))))))));
            case 2
                S_ind = find(or(and(month(X)==6,day(X)>=21),or(month(X)==7,or(month(X)==8,or(month(X)==9, or(month(X)==10, ...
                    or(month(X)==11, and(month(X)==12,day(X)<21))))))));
       end  
        
        case 4
          
        getbreaks =cat(1,yline{:});
        seasonbreaks = sort(getbreaks(:,1));
        
        if season == length(yline)
         
        S_ind = find(or(dayofyear(seasonbreaks(season))<dayofyear(X),dayofyear(X)<=dayofyear(seasonbreaks(1))));
         
        else
                          
        S_ind = find(and(dayofyear(seasonbreaks(season))<dayofyear(X),dayofyear(X)<=dayofyear(seasonbreaks(season+1))));
        
        end
       
       
   end

       
    Yseas = Y(S_ind);
    Xseas =  X(S_ind);
    Nd_indseas = Nd_ind(S_ind);
    Md_indseas = Md_ind(S_ind);


end

