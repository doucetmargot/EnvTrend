function varargout = OutputMKseasonal_results(varargin)

 % Code for interface displaying autocorrelation functions and results of
 % seasonal Mann-Kendall analysis

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @OutputMKseasonal_results_OpeningFcn, ...
                   'gui_OutputFcn',  @OutputMKseasonal_results_OutputFcn, ...
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

% --- Executes just before OutputMKseasonal_results is made visible.
function OutputMKseasonal_results_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for OutputMKseasonal_results
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

global cocheader Ntotobs Nndobs Xallseasons Yallseasons p p_corr Senline I Nd_indallseasons significancelevel Sfinal Senline_min Senline_max

axes(handles.axes1);




if p < 0.000001
    set(handles.pnorm,'String','< 1e-6'); 
else
    set(handles.pnorm,'String',num2str(p,'%#.2g'));
end
if p_corr < 0.000001
    set(handles.plog,'String','< 1e-6'); 
else
    set(handles.plog,'String',num2str(p_corr,'%#.2g'));
end


set(handles.resnorm,'String',makeresstringMK(p, Sfinal));
set(handles.reslog,'String',makeresstringMK(p_corr, Sfinal));

global seasonindex
    switch seasonindex
         
        case 1
           global I1 I2 I3 I4 I5 I6 I7 I8 I9 I10 I11 I12
           
           if length (I1) > 1           
           subplot(5,3,1)
           autocorr(I1)
           title('January')
           ylabel('Autocorrelation')
           end
           
           if length (I2) > 1
           subplot(5,3,2)
           autocorr(I2)
           title('February')
           ylabel('Autocorrelation')
           end
           
           if length (I3) > 1
           subplot(5,3,3)
           autocorr(I3)
           title('March')
           ylabel('Autocorrelation')
           end
           
           if length (I4) > 1
           subplot(5,3,4)
           autocorr(I4)
           title('April')
           ylabel('Autocorrelation')
           end
           
           if length (I5) > 1
           subplot(5,3,5)
           autocorr(I5)
           title('May')
           ylabel('Autocorrelation')
           end
           
           if length (I6) > 1
           subplot(5,3,6)
           autocorr(I6)
           title('June')
           ylabel('Autocorrelation')
           end
           
           if length (I7) > 1
           subplot(5,3,7)
           autocorr(I7)
           title('July')
           ylabel('Autocorrelation')
           end
           
           if length (I8) > 1
           subplot(5,3,8)
           autocorr(I8)
           title('August')
           ylabel('Autocorrelation')
           end
           
           if length (I9) > 1
           subplot(5,3,9)
           autocorr(I9)
           title('September')
           ylabel('Autocorrelation')
           end
           
           if length (I10) > 1
           subplot(5,3,10)
           autocorr(I10)
           title('October')
           ylabel('Autocorrelation')
           end
           
           if length (I11) > 1
           subplot(5,3,11)
           autocorr(I11)
           title('November')
           ylabel('Autocorrelation')
           end
           
           if length (I12) > 1
           subplot(5,3,12)
           autocorr(I12)
           title('December')
           ylabel('Autocorrelation')
           end
           
        case 2
          global I1 I2 I3 I4 
           
           if length (I1) > 1
           subplot(3,2,1)
           autocorr(I1)
           title('Winter')
           end
           
           if length (I2) > 1
           subplot(3,2,2)
           autocorr(I2)
           title('Spring')
           end
           
           if length (I3) > 1
           subplot(3,2,3)
           autocorr(I3)
           title('Summer')
           end
           
           if length (I4) > 1
           subplot(3,2,4)
           autocorr(I4)
           title('Fall')
           end
           
        case 3
           global I1 I2
           subplot(3,1,1)
           autocorr(I1)
           title('Winter/Spring')
           subplot(3,1,2)
           autocorr(I2)
           title('Summer/Fall')
           
        case 4
           
           string = makecustomseasonstring;
           global Icustomseasons
           subplot(5,3,1)
           
           
           autocorr(Icustomseasons{1})
           ylabel('Autocorrelation')
           title(string(1))
           subplot(5,3,2)
           
         
           autocorr(Icustomseasons{2})
           title(string(2))
           ylabel('Autocorrelation')
           if  length(Icustomseasons)>2
           subplot(5,3,3)
           
           
           
           autocorr(Icustomseasons{3})
           title(string(3))
           ylabel('Autocorrelation')
           end
           if  length(Icustomseasons)>3
           subplot(5,3,4)
           
           
           autocorr(Icustomseasons{4})
           title(string(4))
           ylabel('Autocorrelation')
           end
           if  length(Icustomseasons)>4
           subplot(5,3,5)
           
           
           autocorr(Icustomseasons{5})
           title(string(5))
           ylabel('Autocorrelation')
           end
           if  length(Icustomseasons)>5
           subplot(5,3,6)
           
           
           autocorr(Icustomseasons{6})
           title(string(6))
           ylabel('Autocorrelation')
           end
           if  length(Icustomseasons)>6
           subplot(5,3,7)
           
           
           autocorr(Icustomseasons{7})
           title(string(7))
           ylabel('Autocorrelation')
           end
           if  length(Icustomseasons)>7
           subplot(5,3,8)
           
           
           autocorr(Icustomseasons{8})
           title(string(8))
           ylabel('Autocorrelation')
           end
           if  length(Icustomseasons)>8
           subplot(5,3,9)
           
           
           autocorr(Icustomseasons{9})
           title(string(9))
           ylabel('Autocorrelation')
           end
           if  length(Icustomseasons)>9
           subplot(5,3,10)
           
           
           autocorr(Icustomseasons{10})
           title(string(10))
           ylabel('Autocorrelation')
           end
           if  length(Icustomseasons)>10
           subplot(5,3,11)
           
           
           autocorr(Icustomseasons{11})
           title(string(11))
           ylabel('Autocorrelation')
           end
           if  length(Icustomseasons)>11
           subplot(5,3,12)
           autocorr(Icustomseasons{12})
           title(string(12))
           
           ylabel('Autocorrelation')
           end
    end





% UIWAIT makes OutputMKseasonal_results wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = OutputMKseasonal_results_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;




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


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
OutputMK_results_help