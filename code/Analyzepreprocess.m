function [] = Analyzepreprocess(i)

%Function conducts preprocessing and initializes analysis

global DATA stationid_index samplingdate_index groupid_index...
analysisparameter_index GroupingSel ...%('No Groups','Define by Database Field', or defined manually)
groupnamelist group1stations group2stations ....
group3stations group4stations dateformat setstoanalyze

if strcmp(dateformat,'number')
    Datelist = DATA(:,samplingdate_index);
else
Datelist = datenum(DATA(:,samplingdate_index),dateformat); % convert dates to number format
end 

 nondetect_index = ~cellfun(@isempty,(strfind(DATA(:,analysisparameter_index),'<'))); % index values of non-detects
 
 maxdetect_index = ~cellfun(@isempty,(strfind(DATA(:,analysisparameter_index),'>'))); % index values of values above max detection limit
 
pass1 = strrep(DATA(:,analysisparameter_index),'<','');% remove non-numeric characters 

pass2 = strrep(pass1,'>',''); % remove non-numeric characters NOTE GREATER THAN MAX VALUES REPLACED BY MAX VALUES!!!

analysisvalues = str2double(pass2); %extract number values from DATA 

if strcmp(GroupingSel,'No Groups');

        stationvalues_index = find(strcmp(DATA(:,stationid_index),setstoanalyze{i}));
        
       compute(stationvalues_index, analysisvalues, Datelist, nondetect_index,maxdetect_index);

 

elseif strcmp(GroupingSel,'Define by Database Field');
            
    
        
       if ismember(setstoanalyze{i},groupnamelist);  %Is selection group of stations?
           stationvalues_index = find(strcmp(DATA(:,groupid_index),setstoanalyze{i}));
       else
           stationvalues_index = find(strcmp(DATA(:,stationid_index),setstoanalyze{i}));    
       end
    
       compute(stationvalues_index, analysisvalues,...
        Datelist, nondetect_index,maxdetect_index);
       
    
else
     
      
        
       if ismember(setstoanalyze{i},groupnamelist);  %Is selection group of stations?
           
           group_index = find(strcmp(groupnamelist,setstoanalyze{i})); %if yes, which group?
           
                if group_index == 1;
                stationvalues_index = find(ismember(DATA(:,stationid_index),group1stations));
                elseif group_index == 2;
                stationvalues_index = find(ismember(DATA(:,stationid_index),group2stations));
                elseif group_index ==3;
                stationvalues_index = find(ismember(DATA(:,stationid_index),group3stations));
                else
                stationvalues_index = find(ismember(DATA(:,stationid_index),group4stations));
                end
       else
           stationvalues_index = find(strcmp(DATA(:,stationid_index),setstoanalyze{i}));    
       end
       
       compute(stationvalues_index, analysisvalues,Datelist, nondetect_index,maxdetect_index);
       
end 
end
    


           
   
        
        
        
        
        
        
        
        
        
        
        