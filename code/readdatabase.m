global Filename Pathname sheetnum Sheet

% reads entire .xls file sheet to the variable 'Sheet' 

maindir = pwd;


    
   cd(Pathname);
   
   Sheet = readtable(Filename,'Sheet',sheetnum,'ReadVariableNames',1);

   cd(maindir);    

    

