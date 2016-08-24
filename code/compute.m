function [] = compute(stationvalues_index, analysisvalues,...
        Datelist, nondetect_index,maxdetect_index)
    
    % function initiated from function 'Analyzepreprocess'
    % This steps takes preprocessed data and passes it to appropriate
    % function based on selected analysis

global maxeventlength ...
significancelevel ...
analysistypeindex ... %(1 is MLE, 2 MK/ATS)
seasonalornotindex... % (1 is not, 2 is)
seasonindex % (1 is monthly, 2 is 4 per year (Summer, Sping, Winter, Fall), 3 is 2 per year (Winter & Sping, Summer & Fall)



if analysistypeindex == 1;
    LR(stationvalues_index, analysisvalues,...
        Datelist, nondetect_index,maxdetect_index,...
        significancelevel);
else
    if seasonalornotindex == 1;
    MK(stationvalues_index, analysisvalues,...
        Datelist, nondetect_index,maxdetect_index,...
        significancelevel,maxeventlength);
    else
    MKseasonal(stationvalues_index, analysisvalues,...
        Datelist, nondetect_index,maxdetect_index,...
        significancelevel,maxeventlength,seasonindex);
    end
end
end

    
    
 

