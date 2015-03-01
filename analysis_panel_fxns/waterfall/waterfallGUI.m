function varargout = waterfallGUI(varargin)
% WATERFALLGUI MATLAB code for waterfallGUI.fig
%      WATERFALLGUI, by itself, creates a new WATERFALLGUI or raises the existing
%      singleton*.
%
%      H = WATERFALLGUI returns the handle to a new WATERFALLGUI or the handle to
%      the existing singleton*.
%
%      WATERFALLGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WATERFALLGUI.M with the given input arguments.
%
%      WATERFALLGUI('Property','Value',...) creates a new WATERFALLGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before waterfallGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to waterfallGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help waterfallGUI

% Last Modified by GUIDE v2.5 29-Apr-2014 17:55:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @waterfallGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @waterfallGUI_OutputFcn, ...
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


% --- Executes just before waterfallGUI is made visible.
function waterfallGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to waterfallGUI (see VARARGIN)

% global handles;

% Choose default command line output for waterfallGUI
handles.output = hObject;

handles=init(handles,varargin);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes waterfallGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = waterfallGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on mouse press over axes background.
function preview_axes_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to preview_axes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% display('hello')
ax_1=handles.preview_axes;
axes(ax_1);
% point1 = get(handles.preview_axes,'CurrentPoint');
point1 = get(ax_1,'CurrentPoint');
finalRect = rbbox;
point2 = get(ax_1,'CurrentPoint');

point1 = point1(1,1:2);
point2 = point2(1,1:2);

minx = min([point1(1),point2(1)]);
miny = min([point1(2),point2(2)]);
maxx = max([point1(1),point2(1)]);
maxy = max([point1(2),point2(2)]);
handles.roi.minx=round(minx);
handles.roi.miny=round(miny);
handles.roi.maxx=round(maxx);
handles.roi.maxy=round(maxy);
display(handles.roi)
roi = [minx,miny,abs(point1(1)-point2(1)),abs(point1(2)-point2(2))];
handles.roi.rect = roi;
plotpreview(handles);
% rectangle('Position',roi,'edgecolor','r','linewidth',2,'linestyle','--');

guidata(hObject, handles);

% --- Executes on slider movement.
function imageslider_Callback(hObject, eventdata, handles)
% hObject    handle to imageslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
value = get(hObject,'Value');
setslider(value,handles.imageslider,handles.imagesliderText);
plotpreview(handles);


% --- Executes during object creation, after setting all properties.
function imageslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imageslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in waterfallbtn.
function waterfallbtn_Callback(hObject, eventdata, handles)
% hObject    handle to waterfallbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = createwaterfall(handles);
guidata(hObject, handles);

% --- Executes on button press in rotation.
function rotation_Callback(hObject, eventdata, handles)
% hObject    handle to rotation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rotation



function imagesliderText_Callback(hObject, eventdata, handles)
% hObject    handle to imagesliderText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of imagesliderText as text
%        str2double(get(hObject,'String')) returns contents of imagesliderText as a double


% --- Executes during object creation, after setting all properties.
function imagesliderText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imagesliderText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on mouse press over axes background.
function output_axes_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to output_axes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

display('hi there');


% --- Executes on slider movement.
function Maxcounts_Callback(hObject, eventdata, handles)
% hObject    handle to Maxcounts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

value = get(hObject,'Value');
setslider(value,handles.Maxcounts,handles.MaxcountsText);

fix_max_min_values('min',handles);

handles=plotoutput(handles);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function Maxcounts_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Maxcounts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function MaxcountsText_Callback(hObject, eventdata, handles)
% hObject    handle to MaxcountsText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MaxcountsText as text
%        str2double(get(hObject,'String')) returns contents of MaxcountsText as a double


% --- Executes during object creation, after setting all properties.
function MaxcountsText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MaxcountsText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function Mincounts_Callback(hObject, eventdata, handles)
% hObject    handle to Mincounts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

value = get(hObject,'Value');
setslider(value,handles.Mincounts,handles.MincountsText);

fix_max_min_values('max',handles);

handles=plotoutput(handles);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function Mincounts_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Mincounts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function MincountsText_Callback(hObject, eventdata, handles)
% hObject    handle to MincountsText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MincountsText as text
%        str2double(get(hObject,'String')) returns contents of MincountsText as a double


% --- Executes during object creation, after setting all properties.
function MincountsText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MincountsText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
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
camname = handles.handles_main.camname;
xlabel  = '';
ylabel  = '';
print2elog(handles,handles.output_axes,@plotout,comment,camname,xlabel,ylabel,handles.handles_main.data)


% --- Executes on selection change in sortvar.
function sortvar_Callback(hObject, eventdata, handles)
% hObject    handle to sortvar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns sortvar contents as cell array
%        contents{get(hObject,'Value')} returns selected item from sortvar


% --- Executes during object creation, after setting all properties.
function sortvar_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sortvar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
