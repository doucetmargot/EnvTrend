function varargout = OutputLR(varargin)

% Code for interface of linear regression output

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @OutputLR_OpeningFcn, ...
                   'gui_OutputFcn',  @OutputLR_OutputFcn, ...
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

% --- Executes just before OutputLR is made visible.
function OutputLR_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for OutputLR
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

global cocheader Xi Yi PARSnormi pnormi PARS_logi PARS_gami plognormi pgami Nd_indi Md_indi Ntotobs Nndobs Nmdobs
%(initial outputs from linear regression to pass to output)

d_indi = and(~Nd_indi,~Md_indi);

axes(handles.axes1);
plot(Xi(d_indi),Yi(d_indi),'bo',...
    Xi(Nd_indi),Yi(Nd_indi),'bv',Xi(Md_indi),Yi(Md_indi),'b^',...
    Xi,polyval(PARSnormi(1:2),Xi),'r',Xi,10.^(polyval(PARS_logi(1:2),Xi)),'c',Xi,polyval(PARS_gami(1:2),Xi),'g')
if sum(Nd_indi)>0;
    if sum(Md_indi)>0;
        legend('Observed Values','Observed Values - NDs','Observed Values - Max.Ds','Linear Model: Normal Distribution','Linear Model: Lognormal Distribution','Linear Model: Gamma Distribution','Location','NorthEast')
    else
        legend('Observed Values','Observed Values - NDs','Linear Model: Normal Distribution','Linear Model: Lognormal Distribution','Linear Model: Gamma Distribution','Location','NorthEast')
    end
else
    if sum(Md_indi)>0;
    legend('Observed Values','Observed Values - Max.Ds','Linear Model: Normal Distribution','Linear Model: Lognormal Distribution','Linear Model: Gamma Distribution','NorthEast')
    else
    legend('Observed Values','Linear Model: Normal Distribution','Linear Model: Lognormal Distribution','Linear Model: Gamma Distribution','NorthEast')
    end
end
xlabel('Date')
ylabel(cocheader) %To update!!!

datetick('x','mmm-yy')
title('MLE Linear Regression')

if pnormi < 0.000001
    set(handles.pnorm,'String','< 1e-6');
else
    set(handles.pnorm,'String',num2str(pnormi,'%.2g'));
end
if plognormi < 0.000001
    set(handles.plog,'String','< 1e-6');
else
    set(handles.plog,'String',num2str(plognormi,'%.2g'));
end
if pgami < 0.000001
    set(handles.pgamma,'String','< 1e-6');   
else
    set(handles.pgamma,'String',num2str(pgami,'%.2g'));
end



set(handles.N,'String',sprintf('Total data points: %d',Ntotobs));
set(handles.Nnd,'String',sprintf('Number of non-detects: %d',Nndobs));
set(handles.text21,'String',sprintf('Number of max.-detects: %d',Nmdobs));


set(handles.resnorm,'String',makeresstring(pnormi, PARSnormi(1)));
set(handles.reslog,'String',makeresstringlog(plognormi, PARS_logi(1)));
set(handles.resgamma,'String',makeresstring(pgami, PARS_gami(1)));

% UIWAIT makes OutputLR wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = OutputLR_OutputFcn(hObject, eventdata, handles)
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

global Ntotobs Nndobs Xi Yi PARSnormi pnormi PARS_logi PARS_gami plognormi pgami Nd_indi Md_indi cocheader Nmdobs


d_indi = and(~Nd_indi,~Md_indi);
axes(handles.axes1);
plot(Xi(d_indi),Yi(d_indi),'bo',...
    Xi(Nd_indi),Yi(Nd_indi),'bv',Xi(Md_indi),Yi(Md_indi),'b^',...
    Xi,polyval(PARSnormi(1:2),Xi),'r',Xi,10.^(polyval(PARS_logi(1:2),Xi)),'c',Xi,polyval(PARS_gami(1:2),Xi),'g')
if sum(Nd_indi)>0;
    if sum(Md_indi)>0;
        legend('Observed Values','Observed Values - NDs','Observed Values - Max.Ds','Linear Model: Normal Distribution','Linear Model: Lognormal Distribution','Linear Model: Gamma Distribution','Location','NorthEast')
    else
        legend('Observed Values','Observed Values - NDs','Linear Model: Normal Distribution','Linear Model: Lognormal Distribution','Linear Model: Gamma Distribution','Location','NorthEast')
    end
else
    if sum(Md_indi)>0;
    legend('Observed Values','Observed Values - Max.Ds','Linear Model: Normal Distribution','Linear Model: Lognormal Distribution','Linear Model: Gamma Distribution','NorthEast')
    else
    legend('Observed Values','Linear Model: Normal Distribution','Linear Model: Lognormal Distribution','Linear Model: Gamma Distribution','NorthEast')
    end
end

xlabel('Date')
ylabel(cocheader) %To update!!!

datetick('x','mmm-yy')
title('MLE Linear Regression')



if pnormi < 0.000001
    set(handles.pnorm,'String','< 1e-6');
else
    set(handles.pnorm,'String',num2str(pnormi,'%.2g'));
end
if plognormi < 0.000001
    set(handles.plog,'String','< 1e-6');
else
    set(handles.plog,'String',num2str(plognormi,'%.2g'));
end
if pgami < 0.000001
    set(handles.pgamma,'String','< 1e-6');   
else
    set(handles.pgamma,'String',num2str(pgami,'%.2g'));
end



set(handles.N,'String',sprintf('Total data points: %d',Ntotobs));
set(handles.Nnd,'String',sprintf('Number of non-detects: %d',Nndobs));
set(handles.text21,'String',sprintf('Number of max.-detects: %d',Nmdobs));

set(handles.resnorm,'String',makeresstring(pnormi, PARSnormi(1)));
set(handles.reslog,'String',makeresstringlog(plognormi, PARS_logi(1)));
set(handles.resgamma,'String',makeresstring(pgami, PARS_gami(1)));






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
global Xi Yi  PARSnormi Nd_indi Md_indi
plotresidualsnorm(Xi,Yi,PARSnormi,Nd_indi, Md_indi) 


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
global Xi Yi PARS_logi Nd_indi Md_indi
plotresidualslognorm(Xi,Yi,PARS_logi,Nd_indi, Md_indi) 

% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
global Xi Yi PARS_gami Nd_indi Md_indi
plotresidualsgam(Xi,Yi,PARS_gami,Nd_indi, Md_indi) 

% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
OutputLR_help
