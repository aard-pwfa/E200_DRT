function varargout = flowplot2D_gui(varargin)
% FLOWPLOT2D_GUI MATLAB code for flowplot2D_gui.fig
%      FLOWPLOT2D_GUI, by itself, creates a new FLOWPLOT2D_GUI or raises the existing
%      singleton*.
%
%      H = FLOWPLOT2D_GUI returns the handle to a new FLOWPLOT2D_GUI or the handle to
%      the existing singleton*.
%
%      FLOWPLOT2D_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FLOWPLOT2D_GUI.M with the given input arguments.
%
%      FLOWPLOT2D_GUI('Property','Value',...) creates a new FLOWPLOT2D_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before flowplot2D_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to flowplot2D_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help flowplot2D_gui

% Last Modified by GUIDE v2.5 18-Dec-2014 18:22:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @flowplot2D_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @flowplot2D_gui_OutputFcn, ...
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


% --- Executes just before flowplot2D_gui is made visible.
function flowplot2D_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to flowplot2D_gui (see VARARGIN)

% Choose default command line output for flowplot2D_gui
handles.output = hObject;

handles=init_flowplot2D(handles,varargin);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes flowplot2D_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = flowplot2D_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in dim2.
function dim2_Callback(hObject, eventdata, handles)
% hObject    handle to dim2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns dim2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from dim2

handles = plotquiver(handles);
[title,xlabel,ylabel] = label_quiverplot(handles);

% --- Executes during object creation, after setting all properties.
function dim2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dim2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in dim1.
function dim1_Callback(hObject, eventdata, handles)
% hObject    handle to dim1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns dim1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from dim1

handles = plotquiver(handles);
[title,xlabel,ylabel] = label_quiverplot(handles);

% --- Executes during object creation, after setting all properties.
function dim1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dim1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in print2elog.
function print2elog_Callback(hObject, eventdata, handles)
% hObject    handle to print2elog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

comment = get(handles.handles_main.Comment,'String');
[title,xlabel,ylabel] = label_quiverplot(handles);
print2elog(handles,handles.mainaxes,@plotquiver,comment,title,xlabel,ylabel,handles.handles_main.data)

