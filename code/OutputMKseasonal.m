function varargout = OutputMKseasonal(varargin)

% Code for interface of seasonal Mann-Kendall output

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @OutputMKseasonal_OpeningFcn, ...
                   'gui_OutputFcn',  @OutputMKseasonal_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before OutputMKseasonal is made visible.
function OutputMKseasonal_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for OutputMKseasonal
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

global cocheader Ntotobs Nndobs Xallseasons Yallseasons Akritas_Theil_Sen_line Senline Nd_indallseasons Md_indallseasons significancelevel Sfinal Senline_min Senline_max Nmdobs

axes(handles.axes1);

X = Xallseasons;
Y = Yallseasons;
Nd_ind = Nd_indallseasons;
Md_ind = Md_indallseasons;

[Xseas, Yseas,Nd_indseas,Md_indseas] = plotseas(1,X,Y,Nd_ind,Md_ind);

d_ind = and(~Nd_ind,~Md_ind);
d_indseas = and(~Nd_indseas,~Md_indseas);


 plot(X(d_ind),Y(d_ind),'co', X(Nd_ind),Y(Nd_ind),'cv',X(Md_ind),Y(Md_ind),'c^',Xseas(d_indseas),Yseas(d_indseas),'ko', Xseas(Nd_indseas),Yseas(Nd_indseas),'kv',Xseas(Md_indseas),Yseas(Md_indseas),'k^',Xseas,linefromsens(Xseas,Yseas,Akritas_Theil_Sen_line(get(handles.popupmenu2, 'Value'))),'k')
 
if sum(Nd_ind)>0
   if sum(Nd_indseas)>0;
       if sum(Md_indseas)>0;
        legend('Observed Values All','Observed Values - NDs All','Observed Values - Max.Ds All','Observed Values: Selected Season','Observed Values - NDs: Selected Season', 'Observed Values - Max.Ds: Selected Season','Akritas-Theil-Sen Slope','Location','NorthEast')
       else
        if sum(Md_ind)>0;
        legend('Observed Values All','Observed Values - NDs All','Observed Values - Max.Ds All','Observed Values: Selected Season','Observed Values - NDs: Selected Season','Akritas-Theil-Sen Slope','Location','NorthEast')
        else
        legend('Observed Values All','Observed Values - NDs All','Observed Values: Selected Season','Observed Values - NDs: Selected Season', 'Akritas-Theil-Sen Slope','Location','NorthEast')
        end
       end
   else
       if sum(Md_indseas)>0;
        legend('Observed Values All','Observed Values - NDs All','Observed Values - Max.Ds All','Observed Values: Selected Season','Observed Values - Max.Ds: Selected Season','Akritas-Theil-Sen Slope','Location','NorthEast')
       else
           if sum(Md_ind)>0;
               legend('Observed Values All','Observed Values - NDs All','Observed Values - Max.Ds All','Observed Values: Selected Season','Akritas-Theil-Sen Slope','Location','NorthEast')
           else
               legend('Observed Values All','Observed Values - NDs All','Observed Values: Selected Season','Akritas-Theil-Sen Slope','Location','NorthEast')
           end
       end
   end
else
    if sum(Md_indseas)>0;
        legend('Observed Values: All','Observed Values - Max.Ds All','Observed Values: Selected Season','Observed Values - Max.Ds: Selected Season','Akritas-Theil-Sen Slope','Location','NorthEast')
    else
        if sum(Md_ind)>0;
             legend('Observed Values: All','Observed Values - Max.Ds All','Observed Values: Selected Season','Akritas-Theil-Sen Slope','Location','NorthEast')
        else
            legend('Observed Values: All','Observed Values: Selected Season','Akritas-Theil-Sen Slope','Location','NorthEast')
        end
    end
end

xlabel('Date')
ylabel(cocheader) %To update!!!

datetick('x','mmm-yy')




set(handles.N,'String',sprintf('Total data points: %d',Ntotobs));
set(handles.Nnd,'String',sprintf('Number of non-detects: %d',Nndobs));
set(handles.text19,'String',sprintf('Number of max.-detects: %d',Nmdobs));

  if sum(Nd_indseas) + sum(Md_indseas) > 0
   set(handles.text18,'String',sprintf('Theil-Sen Slope (90%% CI) = %#.2g - %#.2g /year',Senline_min(1)*365.25, Senline_max(1)*365.25));
  else
   set(handles.text18,'String',sprintf('Theil-Sen Slope = %#.2g/year',Senline_min(1)*365.25));
  end
  
  
 if abs(Akritas_Theil_Sen_line(1))*365.25 >= 1e-6 ;

    set(handles.text14,'String',sprintf('Akritas-Theil-Sen Slope = %#.2g/year',Akritas_Theil_Sen_line(1)*365.25));

 elseif isnan(Akritas_Theil_Sen_line(1));
     
     set(handles.text14,'String','Akritas-Theil-Sen Slope = NaN');
     
 else
     
     set(handles.text14,'String','Akritas-Theil-Sen Slope < 1e-6/year');
 end




% UIWAIT makes OutputMKseasonal wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = OutputMKseasonal_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
cla;

popup_sel_index = get(handles.popupmenu1, 'Value');


Analyzepreprocess(popup_sel_index)

global cocheader Ntotobs Nndobs Xallseasons Yallseasons Akritas_Theil_Sen_line Senline I Nd_indallseasons Md_indallseasons significancelevel Sfinal Senline_min Senline_max Nmdobs
axes(handles.axes1);


X = Xallseasons;
Y = Yallseasons;
Nd_ind = Nd_indallseasons;
Md_ind = Md_indallseasons;

[Xseas, Yseas,Nd_indseas,Md_indseas] = plotseas(get(handles.popupmenu2,'Value'),X,Y,Nd_ind,Md_ind);

d_ind = and(~Nd_ind,~Md_ind);
d_indseas = and(~Nd_indseas,~Md_indseas);


 plot(X(d_ind),Y(d_ind),'co', X(Nd_ind),Y(Nd_ind),'cv',X(Md_ind),Y(Md_ind),'c^',Xseas(d_indseas),Yseas(d_indseas),'ko', Xseas(Nd_indseas),Yseas(Nd_indseas),'kv',Xseas(Md_indseas),Yseas(Md_indseas),'k^',Xseas,linefromsens(Xseas,Yseas,Akritas_Theil_Sen_line(get(handles.popupmenu2, 'Value'))),'k')
 
if sum(Nd_ind)>0
   if sum(Nd_indseas)>0;
       if sum(Md_indseas)>0;
        legend('Observed Values All','Observed Values - NDs All','Observed Values - Max.Ds All','Observed Values: Selected Season','Observed Values - NDs: Selected Season', 'Observed Values - Max.Ds: Selected Season','Akritas-Theil-Sen Slope','Location','NorthEast')
       else
        if sum(Md_ind)>0;
        legend('Observed Values All','Observed Values - NDs All','Observed Values - Max.Ds All','Observed Values: Selected Season','Observed Values - NDs: Selected Season','Akritas-Theil-Sen Slope','Location','NorthEast')
        else
        legend('Observed Values All','Observed Values - NDs All','Observed Values: Selected Season','Observed Values - NDs: Selected Season', 'Akritas-Theil-Sen Slope','Location','NorthEast')
        end
       end
   else
       if sum(Md_indseas)>0;
        legend('Observed Values All','Observed Values - NDs All','Observed Values - Max.Ds All','Observed Values: Selected Season','Observed Values - Max.Ds: Selected Season','Akritas-Theil-Sen Slope','Location','NorthEast')
       else
           if sum(Md_ind)>0;
               legend('Observed Values All','Observed Values - NDs All','Observed Values - Max.Ds All','Observed Values: Selected Season','Akritas-Theil-Sen Slope','Location','NorthEast')
           else
               legend('Observed Values All','Observed Values - NDs All','Observed Values: Selected Season','Akritas-Theil-Sen Slope','Location','NorthEast')
           end
       end
   end
else
    if sum(Md_indseas)>0;
        legend('Observed Values: All','Observed Values - Max.Ds All','Observed Values: Selected Season','Observed Values - Max.Ds: Selected Season','Akritas-Theil-Sen Slope','Location','NorthEast')
    else
        if sum(Md_ind)>0;
             legend('Observed Values: All','Observed Values - Max.Ds All','Observed Values: Selected Season','Akritas-Theil-Sen Slope','Location','NorthEast')
        else
            legend('Observed Values: All','Observed Values: Selected Season','Akritas-Theil-Sen Slope','Location','NorthEast')
        end
    end
end

xlabel('Date')
ylabel(cocheader) %To update!!!

datetick('x','mmm-yy')

set(handles.N,'String',sprintf('Total data points: %d',Ntotobs));
set(handles.Nnd,'String',sprintf('Number of non-detects: %d',Nndobs));
set(handles.text19,'String',sprintf('Number of max.-detects: %d',Nmdobs));
  
   

  if sum(Nd_indseas) + sum(Md_indseas) > 0
    set(handles.text18,'String',sprintf('Theil-Sen Slope (90%% CI) = %#.2g - %#.2g /year',Senline_min(get(handles.popupmenu2, 'Value'))*365.25, Senline_max(get(handles.popupmenu2, 'Value'))*365.25));
  else
    set(handles.text18,'String',sprintf('Theil-Sen Slope = %#.2g/year',Senline_min(get(handles.popupmenu2, 'Value'))*365.25));
  end
  

  
 if abs(Akritas_Theil_Sen_line(get(handles.popupmenu2, 'Value')))*365.25 >= 1e-6 ;

    set(handles.text14,'String',sprintf('Akritas-Theil-Sen Slope = %#.2g/year',Akritas_Theil_Sen_line(get(handles.popupmenu2, 'Value'))*365.25));

 elseif isnan(Akritas_Theil_Sen_line(get(handles.popupmenu2, 'Value')));
     
     set(handles.text14,'String','Akritas-Theil-Sen Slope = NaN');
     
 else
     
     set(handles.text14,'String','Akritas-Theil-Sen Slope < 1e-6/year');
 end
   





% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)




% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
global setstoanalyze
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
end

set(hObject, 'String', setstoanalyze);


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)

OutputMKseasonal_results 




% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2

global cocheader Xallseasons Yallseasons Senline Akritas_Theil_Sen_line Nd_indallseasons Md_indallseasons Senline_min Senline_max
axes(handles.axes1);


X = Xallseasons;
Y = Yallseasons;
Nd_ind = Nd_indallseasons;
Md_ind = Md_indallseasons;

[Xseas, Yseas,Nd_indseas,Md_indseas] = plotseas(get(handles.popupmenu2,'Value'),X,Y,Nd_ind,Md_ind);

d_ind = and(~Nd_ind,~Md_ind);
d_indseas = and(~Nd_indseas,~Md_indseas);


 plot(X(d_ind),Y(d_ind),'co', X(Nd_ind),Y(Nd_ind),'cv',X(Md_ind),Y(Md_ind),'c^',Xseas(d_indseas),Yseas(d_indseas),'ko', Xseas(Nd_indseas),Yseas(Nd_indseas),'kv',Xseas(Md_indseas),Yseas(Md_indseas),'k^',Xseas,linefromsens(Xseas,Yseas,Akritas_Theil_Sen_line(get(handles.popupmenu2, 'Value'))),'k')
 
if sum(Nd_ind)>0
   if sum(Nd_indseas)>0;
       if sum(Md_indseas)>0;
        legend('Observed Values All','Observed Values - NDs All','Observed Values - Max.Ds All','Observed Values: Selected Season','Observed Values - NDs: Selected Season', 'Observed Values - Max.Ds: Selected Season','Akritas-Theil-Sen Slope','Location','NorthEast')
       else
        if sum(Md_ind)>0;
        legend('Observed Values All','Observed Values - NDs All','Observed Values - Max.Ds All','Observed Values: Selected Season','Observed Values - NDs: Selected Season','Akritas-Theil-Sen Slope','Location','NorthEast')
        else
        legend('Observed Values All','Observed Values - NDs All','Observed Values: Selected Season','Observed Values - NDs: Selected Season', 'Akritas-Theil-Sen Slope','Location','NorthEast')
        end
       end
   else
       if sum(Md_indseas)>0;
        legend('Observed Values All','Observed Values - NDs All','Observed Values - Max.Ds All','Observed Values: Selected Season','Observed Values - Max.Ds: Selected Season','Akritas-Theil-Sen Slope','Location','NorthEast')
       else
           if sum(Md_ind)>0;
               legend('Observed Values All','Observed Values - NDs All','Observed Values - Max.Ds All','Observed Values: Selected Season','Akritas-Theil-Sen Slope','Location','NorthEast')
           else
               legend('Observed Values All','Observed Values - NDs All','Observed Values: Selected Season','Akritas-Theil-Sen Slope','Location','NorthEast')
           end
       end
   end
else
    if sum(Md_indseas)>0;
        legend('Observed Values: All','Observed Values - Max.Ds All','Observed Values: Selected Season','Observed Values - Max.Ds: Selected Season','Akritas-Theil-Sen Slope','Location','NorthEast')
    else
        if sum(Md_ind)>0;
             legend('Observed Values: All','Observed Values - Max.Ds All','Observed Values: Selected Season','Akritas-Theil-Sen Slope','Location','NorthEast')
        else
            legend('Observed Values: All','Observed Values: Selected Season','Akritas-Theil-Sen Slope','Location','NorthEast')
        end
    end
end



xlabel('Date')
ylabel(cocheader) %To update!!!

datetick('x','mmm-yy')


  if sum(Nd_indseas) + sum(Md_indseas) > 0
    set(handles.text18,'String',sprintf('Theil-Sen Slope (90%% CI) = %#.2g - %#.2g /year',Senline_min(get(handles.popupmenu2, 'Value'))*365.25, Senline_max(get(handles.popupmenu2, 'Value'))*365.25));
  else
    set(handles.text18,'String',sprintf('Theil-Sen Slope = %#.2g/year',Senline_min(get(handles.popupmenu2, 'Value'))*365.25));
  end

 if abs(Akritas_Theil_Sen_line(get(handles.popupmenu2, 'Value')))*365.25 >= 1e-6 ;

    set(handles.text14,'String',sprintf('Akritas-Theil-Sen Slope = %#.2g/year',Akritas_Theil_Sen_line(get(handles.popupmenu2, 'Value'))*365.25));

elseif isnan(Akritas_Theil_Sen_line(get(handles.popupmenu2, 'Value')));
     
     set(handles.text14,'String','Akritas-Theil-Sen Slope = NaN');
     
 else
     
     set(handles.text14,'String','Akritas-Theil-Sen Slope < 1e-6/year');
 end


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global seasonindex 
    switch seasonindex
        case 1
            string = {'Jan';'Feb';'Mar';'Apr';'May';'Jun';'Jul';'Aug';'Sept';'Oct';'Nov';'Dec'};
        case 2
            string = {'Winter';'Spring';'Summer';'Fall'};
        case 3
            string = {'Winter/Spring';'Summer/Fall'};
        case 4
            string = makecustomseasonstring;
    end
    
set(hObject, 'String', string);


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
OutputMKseasonal_help
