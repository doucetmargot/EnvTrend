function varargout = customseasons(varargin)
% CUSTOMSEASONS MATLAB code for customseasons.fig

% Code for interface to define custom seasons

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @customseasons_OpeningFcn, ...
                   'gui_OutputFcn',  @customseasons_OutputFcn, ...
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

% --- Executes just before customseasons is made visible.
function customseasons_OpeningFcn(hObject, ~, handles, varargin)

% Choose default command line output for customseasons
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

global X Y Nd_ind cocheader yline numseas
axes(handles.axes1);
md = datenum(1990,month(X),day(X));


numseas = 2;

if sum(Nd_ind)>0;
   p =  plot(md(~Nd_ind),Y(~Nd_ind),'bo', md(Nd_ind),Y(Nd_ind),'bx');
    legend('Observed Values','Observed Values - NDs', 'Location','NorthEast')
else
    p = plot(md(~Nd_ind),Y(~Nd_ind),'bo');
    legend('Observed Values', 'Location','NorthEast')

end

xlabel('Time of Year')
ylabel(cocheader) 
xlim('manual')
xlim([(min(md)-65) (max(md)+65)])
datetick('x','mmm')


for i = 1:2
        
        l{i}= impoint(gca,(datenum(1990,12,31)-datenum(1990,01,01))*(i-1)/2+datenum(1990,01,01),mean(Y));
        yline{i} = getPosition(l{i});
        defline{i} = line([yline{i}(1) yline{i}(1)], [0 max(Y)]);
        addNewPositionCallback(l{i},@(pos)positionChanged(l{i},defline{i},i));
        
end





hold on
assignin('base','p',p);


function positionChanged(h,defline,i)
global Y yline
 yline{i} = getPosition(h);
set(defline,'XData',[yline{i}(1) yline{i}(1)],'YData',[0 max(Y)]);


% --- Outputs from this function are returned to the command line.
function varargout = customseasons_OutputFcn(~, ~, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, ~, handles,p)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);

p = evalin('base','p');

handles.output = hObject;

% Update handles structure


global seasonalornotindex X Y Nd_ind cocheader
popup_sel_index = get(handles.popupmenu1, 'Value');

seasonalornotindex = 1;
Analyzepreprocess(popup_sel_index)
seasonalornotindex = 2;

md = datenum(1990,month(X),day(X));



if sum(Nd_ind)>0;
   delete(p)
   p =  plot(md(~Nd_ind),Y(~Nd_ind),'bo', md(Nd_ind),Y(Nd_ind),'bx');
    legend('Observed Values','Observed Values - NDs', 'Location','NorthEast')
else
   delete(p)
   p=  plot(md(~Nd_ind),Y(~Nd_ind),'bo');
    legend('Observed Values', 'Location','NorthEast')

end

xlabel('Time of Year')
ylabel(cocheader) 
xlim('manual')
xlim([(min(md)-65) (max(md)+65)])
datetick('x','mmm')
assignin('base','p',p);





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



% --- Executes on mouse press over axes background.
function axes1_ButtonDownFcn(~, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


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


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)


axes(handles.axes1);

cla

handles.output = hObject;

% Update handles structure


global X Y Nd_ind cocheader yline numseas

md = datenum(1990,month(X),day(X));

if sum(Nd_ind)>0;

   p =  plot(md(~Nd_ind),Y(~Nd_ind),'bo', md(Nd_ind),Y(Nd_ind),'bx');
    legend('Observed Values','Observed Values - NDs', 'Location','NorthEast')
else
  
   p=  plot(md(~Nd_ind),Y(~Nd_ind),'bo');
    legend('Observed Values', 'Location','NorthEast')

end

xlabel('Time of Year')
ylabel(cocheader) 
xlim('manual')
xlim([(min(md)-65) (max(md)+65)])
datetick('x','mmm')
assignin('base','p',p);


numseas = get(hObject,'Value')+1;

for i = 1:numseas
        
        l{i}= impoint(gca,(datenum(1990,12,31)-datenum(1990,01,01))*(i-1)/numseas+datenum(1990,01,01),mean(Y));
        yline{i} = getPosition(l{i});
        defline{i} = line([yline{i}(1) yline{i}(1)], [0 max(Y)]);
        addNewPositionCallback(l{i},@(pos)positionChanged(l{i},defline{i},i));
        
end


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
close


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
customseasons_help
