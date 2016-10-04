function varargout = setfields(varargin)
%   Code for interface for selecting fields / setting up how database is
%   read



%      SETFIELDS MATLAB code for setfields.fig
%      SETFIELDS, by itself, creates a new SETFIELDS or raises the existing
%      singleton*.
%
%      H = SETFIELDS returns the handle to a new SETFIELDS or the handle to
%      the existing singleton*.
%
%      SETFIELDS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SETFIELDS.M with the given input arguments.
%
%      SETFIELDS('Property','Value',...) creates a new SETFIELDS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before setfields_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to setfields_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help setfields

% Last Modified by GUIDE v2.5 30-Jun-2016 09:34:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @setfields_OpeningFcn, ...
                   'gui_OutputFcn',  @setfields_OutputFcn, ...
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


% --- Executes just before setfields is made visible. Initializes fields to
% default values.
function setfields_OpeningFcn(hObject, ~, handles, varargin)

handles.output = hObject;


guidata(hObject, handles);

global maxeventlength DATA Sheet groupnamelist stationid_index samplingdate_index groupid_index analysisparameter_index...
    stationlist GroupingSel group1stations group2stations group3stations group4stations dateformat 

stationid_index = 1;
samplingdate_index = 1;
groupid_index = NaN;
analysisparameter_index = 1;
groupnamelist = {};
maxeventlength = 1;



alldata = table2cell(Sheet);
Preview = alldata(1:10,:);
DATA = alldata;

GroupingSel = 'No Groups';
stationlist = unique(alldata(:,stationid_index));
dateformat = 'mm/dd/yyyy';



%%Initialize display
set(handles.DataSheet,'ColumnName',Sheet.Properties.VariableNames);
set(handles.DataSheet,'Data',Preview);
set(handles.stationids,'String',Sheet.Properties.VariableNames);
set(handles.samplingdate,'String',Sheet.Properties.VariableNames);
set(handles.groupids,'String',['-none-' Sheet.Properties.VariableNames]);
set(handles.analysisparameter,'String',Sheet.Properties.VariableNames);

set(handles.group1list,'String',unique(alldata(:,1)));
set(handles.group2list,'String',unique(alldata(:,1)));
set(handles.group3list,'String',unique(alldata(:,1)));
set(handles.group4list,'String',unique(alldata(:,1)));
set(handles.group1list,'Max',length(unique((alldata(:,1)))));
set(handles.group2list,'Max',length(unique((alldata(:,1)))));
set(handles.group3list,'Max',length(unique((alldata(:,1)))));
set(handles.group4list,'Max',length(unique((alldata(:,1)))));
group1stations = alldata(1,1);
group4stations = alldata(1,1);
group3stations = alldata(1,1);
group2stations = alldata(1,1);


% UIWAIT makes setfields wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = setfields_OutputFcn(~, ~, handles) 

varargout{1} = handles.output;


% --- Executes on button press in closebutton.
function closebutton_Callback(~, ~, ~)
setanalysis




% Define Header Rows--- Executes on selection change in numheaders.
function numheaders_Callback(hObject, ~, handles)

headerindex = get(hObject,'Value');
global Sheet DATA stationid_index stationlist cocheader group1stations group2stations group3stations group4stations analysisparameter_index headingsfull
Datatosnip=table2cell(Sheet);

DATA = Datatosnip(headerindex:end,:);

headings1 = Sheet.Properties.VariableNames;

stationlist = unique(DATA(:,stationid_index));

if headerindex ==1;
    headingsfull = headings1;
elseif headerindex ==2;
    headingsfull = strcat(headings1,'-',Datatosnip(1,:));
elseif headerindex ==3;
    headingsfull = strcat(headings1,'-',Datatosnip(1,:),'-',Datatosnip(2,:));
elseif headerindex ==4;
    headingsfull = strcat(headings1,'-',Datatosnip(1,:),'-',Datatosnip(2,:),'-',Datatosnip(3,:));
else
    headingsfull = strcat(headings1,'-',Datatosnip(1,:),'-',Datatosnip(2,:),'-',Datatosnip(3,:),'-',Datatosnip(4,:));
end 
set(handles.DataSheet,'ColumnName',headingsfull); % Update displayed headings

% Update pull-down menus based on selection

set(handles.stationids,'String',headingsfull);
set(handles.samplingdate,'String',headingsfull);
set(handles.groupids,'String',['-none-' headingsfull]);
set(handles.analysisparameter,'String',headingsfull);
set(handles.group1list,'String',unique(DATA(:,stationid_index)));
set(handles.group2list,'String',unique(DATA(:,stationid_index)));
set(handles.group3list,'String',unique(DATA(:,stationid_index)));
set(handles.group4list,'String',unique(DATA(:,stationid_index)));
set(handles.group1list,'Max',length(unique(DATA(:,stationid_index))));
set(handles.group2list,'Max',length(unique(DATA(:,stationid_index))));
set(handles.group3list,'Max',length(unique(DATA(:,stationid_index))));
set(handles.group4list,'Max',length(unique(DATA(:,stationid_index))));

cocheader = headingsfull(analysisparameter_index);

set(handles.DataSheet,'Data',Datatosnip(headerindex:9+headerindex,:)); % Update displayed data

group1stations = DATA(1,stationid_index);
group4stations = DATA(1,stationid_index);
group3stations = DATA(1,stationid_index);
group2stations = DATA(1,stationid_index);



% --- Executes on selection change in stationids.
function stationids_Callback(hObject,eventdata, handles)
global stationid_index stationlist DATA group1stations group2stations group3stations group4stations
stationid_index = get(hObject,'Value');
stationlist = unique(DATA(:,stationid_index));
    
    set(handles.group1list,'String',unique(DATA(:,stationid_index)));
    set(handles.group2list,'String',unique(DATA(:,stationid_index)));
    set(handles.group3list,'String',unique(DATA(:,stationid_index)));
    set(handles.group4list,'String',unique(DATA(:,stationid_index)));
    set(handles.group1list,'Max',length(unique(DATA(:,stationid_index))));
    set(handles.group2list,'Max',length(unique(DATA(:,stationid_index))));
    set(handles.group3list,'Max',length(unique(DATA(:,stationid_index))));
    set(handles.group4list,'Max',length(unique(DATA(:,stationid_index))));
    
group1stations = DATA(1,stationid_index);
group4stations = DATA(1,stationid_index);
group3stations = DATA(1,stationid_index);
group2stations = DATA(1,stationid_index);

% --- Executes on selection change in samplingdate.
function samplingdate_Callback(hObject, ~, ~)
global samplingdate_index
samplingdate_index = get(hObject,'Value');

% --- Executes on selection change in groupids.
function groupids_Callback(hObject, ~, ~)
global groupid_index groupnamelist DATA
 usrind = get(hObject,'Value');
 
 if usrind == 1;
     groupid_index = NaN;
 else
     groupid_index = usrind - 1;
     
     groupnamelist = unique(DATA(:,groupid_index));
     
 end
 

% --- Executes on selection change in analysisparameter.
function analysisparameter_Callback(hObject, ~, ~)
global analysisparameter_index cocheader headingsfull
analysisparameter_index = get(hObject,'Value');
cocheader = headingsfull(analysisparameter_index);


% --- Executes during object creation, after setting all properties.
function stationids_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function samplingdate_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function groupids_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function analysisparameter_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function numheaders_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in group1list.
function group1list_Callback(hObject, ~, ~)
global group1stations stationlist
group1stations = stationlist(get(hObject,'Value'));

function group2list_Callback(hObject, ~, ~)
global group2stations stationlist
group2stations = stationlist(get(hObject,'Value'));

function group3list_Callback(hObject, ~, ~)
global group3stations stationlist
group3stations = stationlist(get(hObject,'Value'));

function group4list_Callback(hObject, ~, ~)
global group4stations stationlist
group4stations = stationlist(get(hObject,'Value'));

% --- Executes during object creation, after setting all properties.
function group1list_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%% Reads user-defined group names

function group1name_Callback(hObject, ~, ~)

global groupnamelist

groupnamelist(1) = {get(hObject,'String')};


function group2name_Callback(hObject, ~, ~)

global groupnamelist

groupnamelist(2) = {get(hObject,'String')};


function group3name_Callback(hObject,~,~)

global groupnamelist

groupnamelist(3) = {get(hObject,'String')};


function group4name_Callback(hObject, ~,~)

global groupnamelist

groupnamelist(4) = {get(hObject,'String')};



% --- Executes during object creation, after setting all properties.
function group1name_CreateFcn(hObject,~,~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes during object creation, after setting all properties.
function group3name_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes during object creation, after setting all properties.
function group2name_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function group4name_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function group2list_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function group3list_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function group4list_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in uipanel2.
function uipanel2_SelectionChangeFcn(hObject, ~, handles) 
global groupid_index GroupingSel groupnamelist
GroupingSel = get(hObject,'String');

if strcmp(GroupingSel,'No Groups');
    
    set(handles.text10,'Visible','Off');
    set(handles.text11,'Visible','Off');
    set(handles.text12,'Visible','Off');
    set(handles.text13,'Visible','Off');
    
    set(handles.group1name,'Visible','Off');
    set(handles.group2name,'Visible','Off');
    set(handles.group3name,'Visible','Off');
    set(handles.group4name,'Visible','Off');
    
    set(handles.group1list,'Visible','Off');
    set(handles.group2list,'Visible','Off');
    set(handles.group3list,'Visible','Off');
    set(handles.group4list,'Visible','Off');
    
    set(handles.text3,'Visible','Off');
    set(handles.groupids,'Visible','Off');
    
    groupid_index = NaN;
    groupnamelist = {};
    
elseif strcmp(GroupingSel,'Define by Database Field'); 
    
    set(handles.text10,'Visible','Off');
    set(handles.text11,'Visible','Off');
    set(handles.text12,'Visible','Off');
    set(handles.text13,'Visible','Off');
    
    set(handles.group1name,'Visible','Off');
    set(handles.group2name,'Visible','Off');
    set(handles.group3name,'Visible','Off');
    set(handles.group4name,'Visible','Off');
    
    set(handles.group1list,'Visible','Off');
    set(handles.group2list,'Visible','Off');
    set(handles.group3list,'Visible','Off');
    set(handles.group4list,'Visible','Off');
    
    set(handles.text3,'Visible','On');
    set(handles.groupids,'Visible','On');
       
else
    set(handles.text10,'Visible','On');
    set(handles.text11,'Visible','On');
    set(handles.text12,'Visible','On');
    set(handles.text13,'Visible','On');
    
    set(handles.group1name,'Visible','On');
    set(handles.group2name,'Visible','On');
    set(handles.group3name,'Visible','On');
    set(handles.group4name,'Visible','On');
    
    set(handles.group1list,'Visible','On');
    set(handles.group2list,'Visible','On');
    set(handles.group3list,'Visible','On');
    set(handles.group4list,'Visible','On');
    
    set(handles.text3,'Visible','Off');
    set(handles.groupids,'Visible','Off');
    
    groupnamelist = {'group 1';'group 2';'group 3';'group 4'};
   
end


% --- Executes on selection change in dateformat.
function dateformat_Callback(hObject, ~, ~)
global dateformat
contents = get(hObject,'String');
dateformat = contents(get(hObject,'Value'));


% --- Executes during object creation, after setting all properties.
function dateformat_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function lengthmaxevent_Callback(hObject, ~, ~)

global maxeventlength

maxeventlength = str2double(get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function lengthmaxevent_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(~, ~, ~)

setfields_help
