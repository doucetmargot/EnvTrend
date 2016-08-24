function varargout = OutputMKseasonal_help(varargin)
% OUTPUTMKSEASONAL_HELP MATLAB code for OutputMKseasonal_help.fig
%      OUTPUTMKSEASONAL_HELP, by itself, creates a new OUTPUTMKSEASONAL_HELP or raises the existing
%      singleton*.
%
%      H = OUTPUTMKSEASONAL_HELP returns the handle to a new OUTPUTMKSEASONAL_HELP or the handle to
%      the existing singleton*.
%
%      OUTPUTMKSEASONAL_HELP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OUTPUTMKSEASONAL_HELP.M with the given input arguments.
%
%      OUTPUTMKSEASONAL_HELP('Property','Value',...) creates a new OUTPUTMKSEASONAL_HELP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before OutputMKseasonal_help_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to OutputMKseasonal_help_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help OutputMKseasonal_help

% Last Modified by GUIDE v2.5 01-Jul-2016 18:27:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @OutputMKseasonal_help_OpeningFcn, ...
                   'gui_OutputFcn',  @OutputMKseasonal_help_OutputFcn, ...
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


% --- Executes just before OutputMKseasonal_help is made visible.
function OutputMKseasonal_help_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to OutputMKseasonal_help (see VARARGIN)

% Choose default command line output for OutputMKseasonal_help
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes OutputMKseasonal_help wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = OutputMKseasonal_help_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
