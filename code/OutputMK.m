function varargout = OutputMK(varargin)
% Code for interface of Mann-Kendall output

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @OutputMK_OpeningFcn, ...
                   'gui_OutputFcn',  @OutputMK_OutputFcn, ...
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

% --- Executes just before OutputMK is made visible.
function OutputMK_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for OutputMK
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

global X Y Nd_ind Md_ind Ntotobs Nndobs Senline_min Senline_max cocheader Akritas_Theil_Sen_line Nmdobs

axes(handles.axes1);

d_ind = and(~Nd_ind,~Md_ind);

if sum(Nd_ind)>0
   plot(X(d_ind),Y(d_ind),'bo', X(Nd_ind),Y(Nd_ind),'bv',X(Md_ind),Y(Md_ind),'b^',X,linefromsens(X,Y,Akritas_Theil_Sen_line))
    if sum(Md_ind)>0
       legend('Observed Values','Observed Values - NDs','Observed Values - Max.Ds','Akritas-Theil-Sen Slope','Location','NorthEast')
    else
       legend('Observed Values','Observed Values - NDs', 'Akritas-Theil-Sen Slope','Location','NorthEast')
    end
else
    plot(X(d_ind),Y(d_ind),'bo',X(Md_ind),Y(Md_ind),'b^',X,linefromsens(X,Y,Akritas_Theil_Sen_line))
    if sum(Md_ind)>0
        legend('Observed Values','Observed Values - Max.Ds','Akritas-Theil-Sen Slope','Location','NorthEast')
    else
        legend('Observed Values','Akritas-Theil-Sen Slope','Location','NorthEast')
    end
end

xlabel('Date')
ylabel(cocheader) %To update!!!

datetick('x','mmm-yy')
title('Mann-Kendall Trend Test')

set(handles.N,'String',sprintf('Total data points: %d',Ntotobs));
set(handles.Nnd,'String',sprintf('Number of non-detects: %d',Nndobs));
set(handles.text17,'String',sprintf('Number of max.-detects: %d',Nmdobs));


if sum(Nd_ind)+sum(Md_ind)>0
   set(handles.text16,'String',sprintf('Theil-Sen Slope (90%% CI) = %#.2g - %#.2g/year',Senline_min(1)*365.25,Senline_max(1)*365.25));
else
    set(handles.text16,'String',sprintf('Theil-Sen Slope = %#.2g/year',Senline_min(1)*365.25));
end
    

 if abs(Akritas_Theil_Sen_line(1))*365.25 >= 1e-6 ;

set(handles.text13,'String',sprintf('Akritas-Theil-Sen Slope = %#.2g/year',Akritas_Theil_Sen_line(1)*365.25));

 else
     
     set(handles.text13,'String','Akritas-Theil-Sen Slope < 1e-6/year');
 end


 




% UIWAIT makes OutputMK wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = OutputMK_OutputFcn(hObject, eventdata, handles)
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

global X Y Nd_ind Md_ind Ntotobs Nndobs Senline_min Senline_max cocheader Akritas_Theil_Sen_line Nmdobs
axes(handles.axes1);

d_ind = and(~Nd_ind,~Md_ind);

if sum(Nd_ind)>0
   plot(X(d_ind),Y(d_ind),'bo', X(Nd_ind),Y(Nd_ind),'bv',X(Md_ind),Y(Md_ind),'b^',X,linefromsens(X,Y,Akritas_Theil_Sen_line))
    if sum(Md_ind)>0
       legend('Observed Values','Observed Values - NDs','Observed Values - Max.Ds','Akritas-Theil-Sen Slope','Location','NorthEast')
    else
       legend('Observed Values','Observed Values - NDs', 'Akritas-Theil-Sen Slope','Location','NorthEast')
    end
else
    plot(X(d_ind),Y(d_ind),'bo',X(Md_ind),Y(Md_ind),'b^',X,linefromsens(X,Y,Akritas_Theil_Sen_line))
    if sum(Md_ind)>0
        legend('Observed Values','Observed Values - Max.Ds','Akritas-Theil-Sen Slope','Location','NorthEast')
    else
        legend('Observed Values','Akritas-Theil-Sen Slope','Location','NorthEast')
    end
end

xlabel('Date')
ylabel(cocheader) %To update!!!

datetick('x','mmm-yy')
title('Mann-Kendall Trend Test')


set(handles.N,'String',sprintf('Total data points: %d',Ntotobs));
set(handles.Nnd,'String',sprintf('Number of non-detects: %d',Nndobs));
set(handles.text17,'String',sprintf('Number of max.-detects: %d',Nmdobs));

if sum(Nd_ind)+sum(Md_ind) > 0
   set(handles.text16,'String',sprintf('Theil-Sen Slope (90%% CI) = %#.2g - %#.2g/year',Senline_min(1)*365.25,Senline_max(1)*365.25));
else
    set(handles.text16,'String',sprintf('Theil-Sen Slope = %#.2g/year',Senline_min(1)*365.25));
end

 if abs(Akritas_Theil_Sen_line(1))*365.25 >= 1e-6 ;

set(handles.text13,'String',sprintf('Akritas-Theil-Sen Slope = %#.2g/year',Akritas_Theil_Sen_line(1)*365.25));

 else
     
     set(handles.text13,'String','Akritas-Theil-Sen Slope < 1e-6/year');
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


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
global setstoanalyze
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
end

set(hObject, 'String', setstoanalyze);


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
OutputMK_results
% global I
% figure 
% autocorr(I)


% --- Executes during object creation, after setting all properties.
function Nnd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Nnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
OutputMK_help
