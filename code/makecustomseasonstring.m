function [ output ] = makecustomseasonstring(  )

% function creates string based on user-defined seasons

global yline

        getbreaks =cat(1,yline{:});
        seasonbreaks = sort(getbreaks(:,1));
        
        ns = length(seasonbreaks) ;

for i = 1:ns-1

    [junk month1] = month(seasonbreaks(i));
    [junk month2] = month(seasonbreaks(i+1));

    output{i} = sprintf('%d %s - %d %s',day(seasonbreaks(i)),month1,day(seasonbreaks(i+1)),month2);
    
end

    [junk month1] = month(seasonbreaks(ns));
    [junk month2] = month(seasonbreaks(1));

    output{ns} = sprintf('%d %s - %d %s',day(seasonbreaks(ns)),month1,day(seasonbreaks(1)),month2);


end

