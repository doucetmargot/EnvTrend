function varargout = setanalysis(varargin)
% Code for interface for setting up analysis type and parameters

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @setanalysis_OpeningFcn, ...
                   'gui_OutputFcn',  @setanalysis_OutputFcn, ...
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


% --- Executes just before setanalysis is made visible.
function setanalysis_OpeningFcn(hObject, ~, handles, varargin)

handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


global setstoanalyze stationlist groupnamelist significancelevel analysistypeindex seasonalornotindex seasonindex 
setlist = cat(1,groupnamelist,stationlist);

set(handles.setstoanalyze,'String',setlist);
set(handles.setstoanalyze,'Max',length(setlist))

significancelevel = 0.05;
analysistypeindex = 2;
seasonalornotindex = 1;
seasonindex = 1;
setstoanalyze = setlist(1);



% --- Outputs from this function are returned to the command line.
function varargout = setanalysis_OutputFcn(~, ~, handles) 

varargout{1} = handles.output;


% --- Executes on selection change in setstoanalyze.
function setstoanalyze_Callback(hObject, ~, ~)
global setstoanalyze
contents = cellstr(get(hObject,'String'));
setstoanalyze = contents(get(hObject,'Value'));



% --- Executes during object creation, after setting all properties.
function setstoanalyze_CreateFcn(hObject, ~, ~)


if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in analysistype.
function analysistype_Callback(hObject, ~, handles)
global analysistypeindex seasonalornotindex

analysistypeindex = get(hObject,'Value');

if analysistypeindex == 1;
    set(handles.normalorseasonal,'Visible','Off');
    set(handles.setseasons,'Visible','Off');
    set(handles.pushbutton2,'Visible','Off');
else
    set(handles.normalorseasonal,'Visible','On');
 
    
    if seasonalornotindex == 1;
    set(handles.setseasons,'Visible','Off');
    set(handles.pushbutton2,'Visible','Off');
    else
    set(handles.setseasons,'Visible','On');
    set(handles.pushbutton2,'Visible','On');
    end
    
     
    
end

% --- Executes during object creation, after setting all properties.
function analysistype_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in computebutton.
function computebutton_Callback(~, ~, ~)
Analyzepreprocess(1)
global analysistypeindex seasonalornotindex 
    if analysistypeindex == 1;
        OutputLR
    else        
        if seasonalornotindex == 1 
         OutputMK
        else
         OutputMKseasonal
       end
    end


    
    


function significancelevel_Callback(hObject, ~, ~)
global significancelevel

significancelevel = str2double(get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function significancelevel_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in normalorseasonal.
function normalorseasonal_Callback(hObject, ~, handles)

global seasonalornotindex

seasonalornotindex = get(hObject,'Value');

if seasonalornotindex == 1;
    set(handles.setseasons,'Visible','Off');
    set(handles.pushbutton2,'Visible','Off');
else
    set(handles.setseasons,'Visible','On');

end

% --- Executes during object creation, after setting all properties.
function normalorseasonal_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on selection change in setseasons.
function setseasons_Callback(hObject, ~, handles)

global seasonindex

seasonindex = get(hObject,'Value');

if seasonindex == 4;
    set(handles.pushbutton2,'Visible','On');
else
    set(handles.pushbutton2,'Visible','Off');
end




% --- Executes during object creation, after setting all properties.
function setseasons_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(~, ~, ~)
global seasonindex seasonalornotindex 

seasonalornotindex = 1;
seasonindex = 4;
Analyzepreprocess(1)
seasonalornotindex = 2;
customseasons
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(~, ~, ~)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setanalysis_help
