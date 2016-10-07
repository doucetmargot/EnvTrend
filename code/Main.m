function varargout = Main(varargin)

% Initial program window - Prompts user to select files containing
% database


gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Main_OpeningFcn, ...
                   'gui_OutputFcn',  @Main_OutputFcn, ...
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

% --- Executes just before Main is made visible.
function Main_OpeningFcn(hObject,~, handles, varargin)
global sheetnum

handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
sheetnum = 1;

function varargout = Main_OutputFcn(~, ~, handles)
% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in buttonselectfile.
function buttonselectfile_Callback(~,~, handles)
global Filename Pathname 
[Filename,Pathname] = uigetfile({'*.xls';'*.xlsx'}, 'Select Database Input File');
[~,sheets] = xlsfinfo([Pathname, Filename]);

set(handles.filestring,'String',Filename);
set(handles.xlssheets,'String',sheets);



% --- Executes on button press in setfields.
function setfields_Callback(~, ~, ~)
readdatabase
setfields


% --- Executes on selection change in xlssheets.
function xlssheets_Callback(hObject,~, ~)
global sheetnum
sheetnum = get(hObject,'Value'); 



% --- Executes during object creation, after setting all properties.
function xlssheets_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(~, ~, ~)

Main_help
