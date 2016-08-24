function varargout = OutputMK_help(varargin)
% OUTPUTMK_HELP MATLAB code for OutputMK_help.fig
%      OUTPUTMK_HELP, by itself, creates a new OUTPUTMK_HELP or raises the existing
%      singleton*.
%
%      H = OUTPUTMK_HELP returns the handle to a new OUTPUTMK_HELP or the handle to
%      the existing singleton*.
%
%      OUTPUTMK_HELP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OUTPUTMK_HELP.M with the given input arguments.
%
%      OUTPUTMK_HELP('Property','Value',...) creates a new OUTPUTMK_HELP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before OutputMK_help_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to OutputMK_help_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help OutputMK_help

% Last Modified by GUIDE v2.5 01-Jul-2016 17:50:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @OutputMK_help_OpeningFcn, ...
                   'gui_OutputFcn',  @OutputMK_help_OutputFcn, ...
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


% --- Executes just before OutputMK_help is made visible.
function OutputMK_help_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to OutputMK_help (see VARARGIN)

% Choose default command line output for OutputMK_help
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes OutputMK_help wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = OutputMK_help_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
