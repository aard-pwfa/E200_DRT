function varargout = E200_DRT(varargin)
% E200_DRT M-file for E200_DRT.fig
%      E200_DRT, by itself, creates a new E200_DRT or raises the existing
%      singleton*.
%
%      H = E200_DRT returns the handle to a new E200_DRT or the handle to
%      the existing singleton*.
%
%      E200_DRT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in E200_DRT.M with the given input arguments.
%
%      E200_DRT('Property','Value',...) creates a new E200_DRT or raises
%      the existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before E200_DRT_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to E200_DRT_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help E200_DRT

% Last Modified by GUIDE v2.5 24-Mar-2014 18:01:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',	   mfilename, ...
				   'gui_Singleton',  gui_Singleton, ...
				   'gui_OpeningFcn', @E200_DRT_OpeningFcn, ...
				   'gui_OutputFcn',  @E200_DRT_OutputFcn, ...
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

% --- Executes just before E200_DRT is made visible.
function E200_DRT_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to E200_DRT (see VARARGIN)

if nargin>3
	handles.expstr=varargin{1};
else
	handles.expstr='E200';
end
set(handles.expstrbox,'String',handles.expstr);

% Choose default command line output for E200_DRT
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes E200_DRT wait for user response (see UIRESUME)
% uiwait(handles.figure1);

addpath(fullfile(pwd,'E200_data'));
addpath(genpath(fullfile(pwd,'aux_functions')));

% --- Outputs from this function are returned to the command line.
function varargout = E200_DRT_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% Update handles structure
guidata(handles.figure1, handles);

function currentfile_Callback(hObject, eventdata, handles)
% hObject    handle to currentfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of currentfile as text
%        str2double(get(hObject,'String')) returns contents of currentfile as a double

% --- Executes during object creation, after setting all properties.
function currentfile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to currentfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
	set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over currentfile.
function currentfile_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to currentfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in OpenDataset.
function OpenDataset_Callback(hObject, eventdata, handles)
% hObject    handle to OpenDataset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% global dirs;
% global gl;

% Extract most recent file location
prefix=get_remoteprefix();
searchpath = fullfile(prefix,['/nas/nas-li20-pm01/' get(handles.expstrbox,'String') '/']);
dirs       = dir(searchpath);
% Convert to structure
dirs=struct2cell(dirs);
% Order by date
date=dirs(5,:);
date=cell2mat(date);
[ignore,ind]=sort(date);
dirs=dirs(:,ind);

% Get only directory names
dir_names=dirs(1,:);
% Look for directories with 4-digit
bool1=~cellfun(@isempty,regexp(dir_names,'\d{4}'));
% Directories only 4 characters long.
bool2=cellfun(@(x) length(x)==4,dir_names);
dirs=dirs(:,bool1 & bool2);
first=dirs{1,end};

searchpath = fullfile(searchpath,[first '/']);
dirs       = dir(searchpath);
second     = dirs(end).name;
searchpath = [searchpath second '/'];
dirs       = dir(searchpath);
third      = dirs(end).name;
searchpath = [searchpath third '/'];

searchlist = {{'scan_info.mat','scan'},{'filenames.mat','daq'}};

settype='none';
filtstr='';
for searchstr=searchlist
	desiredfiles=dir(fullfile(searchpath,['*' searchstr{1}{1}]));
	if size(desiredfiles,1)>0
		settype=searchstr{1}{2};
		filtstr=searchstr{1}{1};
		break;
	end
end

switch settype
	case 'scan'
		defaultfile=[third '_' filtstr];
	case 'daq'
		defaultfile=desiredfiles(1).name;
	case 'none'
		defaultfile='';
end

curpath=pwd;
cd(searchpath);
[Filename,Pathname,FilterIndex]=uigetfile('*.mat','Open E200 scan_info file',defaultfile);
cd(curpath);

% Pathname='/nas/nas-li20-pm01/E200/2013/20130511/E200_11071/';
% Filename='E200_11071_scan_info.mat';

% Get the hostname of the computer.
[status,hostname]=unix('hostname');
hostname = strrep(hostname,sprintf('\n'),'');
isfs20=strcmp(hostname,'facet-srv20');

if isfs20
	% loadfile=fullfile('/home/fphysics/joelfred',Pathname,Filename)
	loadfile=fullfile(Pathname,Filename);
else
	loadfile=fullfile(Pathname,Filename);
end

% gl.loadfile=loadfile;
% loadfile = '/home/fphysics/joelfred/nas/nas-li20-pm01/E200/2013/20130428/E200_10836'

data=E200_load_data(loadfile,get(handles.expstrbox,'String'));
% display(data.VersionInfo.Version);

switch data.raw.metadata.settype
	case 'scan'

		% n_steps=size(data.raw.metadata.scan_info,2)
		n_steps = data.raw.metadata.n_steps
		set(handles.Stepstaken,'String',n_steps);
		set(handles.Stepnumberslider,'Min',1);
		set(handles.Stepnumberslider,'Max',n_steps);
		set(handles.Stepnumberslider,'Value',1);
		set(handles.Stepnumberslider,'SliderStep',[1/(n_steps-1),2/(n_steps-1)]);
		set(handles.Stepnumberslider,'Enable','On');
		set(handles.Stepnumbertext,'String',1);
		set(handles.Stepnumbertext,'Enable','on');

		% handles.scan.scan_info=data.raw.metadata.scan_info;
		handles.scan.n_steps=n_steps;
		
	case 'daq'
		
		set(handles.Stepstaken,'String','NOT A SCAN: NO STEPS!');
		
		set(handles.Stepnumberslider,'Enable','Off');
		set(handles.Stepnumbertext,'String','N/A');
	case 'none'
end

% All file initializations
if ~strcmp(data.raw.metadata.settype,'none')
	param=data.raw.metadata.param.dat{1};

	% Set strings
	Cams_str=fieldnames(data.raw.images);
	set(handles.Cams,'String',Cams_str);
	% set(handles.Cams,'Max',size(param.cams,1));

	% Save lookup table
	handles.CamsLookup.datatype=cell_construct('raw',1,size(Cams_str,1));
	handles.CamsLookup.name=Cams_str;
	
	set(handles.currentfile,'String',loadfile);
	set(handles.FileDate,'String',[param.year '-' param.month '-' param.day]);
	
	set(handles.Shotsperstep,'String',param.n_shot);

	set(handles.imageslider,'Min',1);
	set(handles.imageslider,'Max',1);
	set(handles.imageslider,'Value',1);
	set(handles.imageslider,'SliderStep',[1,10]);
	set(handles.imageslider,'Enable','off');

	set(handles.Maxcounts,'Min',1);
	set(handles.Maxcounts,'Max',1);
	set(handles.Maxcounts,'Value',1);
	set(handles.Maxcounts,'SliderStep',[1,10]);
	set(handles.Maxcounts,'Enable','off');

	set(handles.Mincounts,'Min',0);
	set(handles.Mincounts,'Max',1);
	set(handles.Mincounts,'Value',1);
	set(handles.Mincounts,'SliderStep',[1,10]);
	set(handles.Mincounts,'Enable','off');

	corr_str=fieldnames(data.raw.scalars);
	% First is special: just use index.
	corr_str=['As taken';corr_str];
	set(handles.Xcorrpopup,'String',corr_str);
	set(handles.Ycorrpopup,'String',corr_str);

	% Turn things off.
	cla(handles.fig1);
	
	set(handles.Comment,'String',param.comt_str);

 	handles.data=data;   
	
	% gl.param=param;
	% gl.Pathname=Pathname;
	% gl.dirs=dirs;
	% gl.cam_back=cam_back;
	% gl.handles=handles;
end
guidata(hObject,handles);

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over OpenDataset.
function OpenDataset_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to OpenDataset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function FileDate_Callback(hObject, eventdata, handles)
% hObject    handle to FileDate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FileDate as text
%        str2double(get(hObject,'String')) returns contents of FileDate as a double


% --- Executes during object creation, after setting all properties.
function FileDate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FileDate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
	set(hObject,'BackgroundColor','white');
end



function FileTime_Callback(hObject, eventdata, handles)
% hObject    handle to FileTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FileTime as text
%        str2double(get(hObject,'String')) returns contents of FileTime as a double


% --- Executes during object creation, after setting all properties.
function FileTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FileTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
	set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Cams.
function Cams_Callback(hObject, eventdata, handles)
% hObject    handle to Cams (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Cams contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Cams
try
	handles=rmfield(handles,'maxsubpixel');
end

set(handles.imageslider,'Value',1);
handles=loadimages(hObject,handles);
plotpanel(hObject,handles);


% --- Executes during object creation, after setting all properties.
function Cams_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Cams (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
	set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function OpenDataset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OpenDataset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function Stepstaken_Callback(hObject, eventdata, handles)
% hObject    handle to Stepstaken (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Stepstaken as text
%        str2double(get(hObject,'String')) returns contents of Stepstaken as a double


% --- Executes during object creation, after setting all properties.
function Stepstaken_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Stepstaken (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
	set(hObject,'BackgroundColor','white');
end



function Shotsperstep_Callback(hObject, eventdata, handles)
% hObject    handle to Shotsperstep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Shotsperstep as text
%        str2double(get(hObject,'String')) returns contents of Shotsperstep as a double


% --- Executes during object creation, after setting all properties.
function Shotsperstep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Shotsperstep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
	set(hObject,'BackgroundColor','white');
end



function Stepnumberslider_Callback(hObject, eventdata, handles)
% hObject    handle to Stepnumberslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Stepnumberslider as text
%        str2double(get(hObject,'String')) returns contents of Stepnumberslider as a double

% global gl

value = get(hObject,'Value');
setslider(value,handles.Stepnumberslider,handles.Stepnumbertext);

% try
%         handles=rmfield(handles,'maxsubpixel');
% end
handles = loadimages(hObject,handles);
plotpanel(hObject,handles);

% gl.handles=handles;



% --- Executes during object creation, after setting all properties.
function Stepnumberslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Stepnumberslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
	set(hObject,'BackgroundColor','white');
end


function Comment_Callback(hObject, eventdata, handles)
% hObject    handle to Comment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Comment as text
%        str2double(get(hObject,'String')) returns contents of Comment as a double


% --- Executes during object creation, after setting all properties.
function Comment_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Comment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
	set(hObject,'BackgroundColor','white');
end



function Stepnumbertext_Callback(hObject, eventdata, handles)
% hObject    handle to Stepnumbertext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Stepnumbertext as text
%        str2double(get(hObject,'String')) returns contents of Stepnumbertext as a double

value=str2double(get(hObject,'String'));
setslider(value,handles.Stepnumberslider,handles.Stepnumbertext);

% try
%         handles=rmfield(handles,'maxsubpixel');
% end
handles = loadimages(hObject,handles);
plotpanel(hObject,handles);


% --- Executes during object creation, after setting all properties.
function Stepnumbertext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Stepnumbertext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
	set(hObject,'BackgroundColor','white');
end


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

plotpanel(hObject,handles);


% --- Executes during object creation, after setting all properties.
function Maxcounts_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Maxcounts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
	set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in allsteps.
function allsteps_Callback(hObject, eventdata, handles)
% hObject    handle to allsteps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of allsteps


% --- Executes on button press in allshots.
function allshots_Callback(hObject, eventdata, handles)
% hObject    handle to allshots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of allshots


% --- Executes on slider movement.
function imageslider_Callback(hObject, eventdata, handles)
% hObject    handle to imageslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

value = get(hObject,'Value');
setslider(value,handles.imageslider,handles.imagesliderText);

plotpanel(hObject,handles);


% --- Executes during object creation, after setting all properties.
function imageslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imageslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on selection change in Xcorrpopup.
function Xcorrpopup_Callback(hObject, eventdata, handles)
% hObject    handle to Xcorrpopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Xcorrpopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Xcorrpopup


% --- Executes during object creation, after setting all properties.
function Xcorrpopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Xcorrpopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in Ycorrpopup.
function Ycorrpopup_Callback(hObject, eventdata, handles)
% hObject    handle to Ycorrpopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Ycorrpopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Ycorrpopup


% --- Executes during object creation, after setting all properties.
function Ycorrpopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ycorrpopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Corrplotbutton.
function Corrplotbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Corrplotbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% global gl

% gl.hObject=hObject;

handles=corrplot(hObject,handles);

guidata(hObject,handles);


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

plotpanel(hObject,handles);

% --- Executes during object creation, after setting all properties.
function Mincounts_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Mincounts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in yunits.
function yunits_Callback(hObject, eventdata, handles)
% hObject    handle to yunits (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns yunits contents as cell array
%        contents{get(hObject,'Value')} returns selected item from yunits

plotpanel(hObject,handles);

% --- Executes during object creation, after setting all properties.
function yunits_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yunits (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in xunits.
function xunits_Callback(hObject, eventdata, handles)
% hObject    handle to xunits (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns xunits contents as cell array
%        contents{get(hObject,'Value')} returns selected item from xunits

plotpanel(hObject,handles);

% --- Executes during object creation, after setting all properties.
function xunits_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xunits (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in analysisPopup.
function analysisPopup_Callback(hObject, eventdata, handles)
% hObject    handle to analysisPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns analysisPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from analysisPopup


% --- Executes during object creation, after setting all properties.
function analysisPopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to analysisPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

addpath('analysis_panel_fxns');

analysis_panel_init(hObject,handles);
guidata(hObject, handles);

% rmpath('analysis_panel_fxns');

% --- Executes on button press in analysisButton.
function analysisButton_Callback(hObject, eventdata, handles)
% hObject    handle to analysisButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

analysis_struct = analysis_info()

analysis_struct(get(handles.analysisPopup,'Value')).func(handles)


% --- Executes on button press in globaldataButton.
function globaldataButton_Callback(hObject, eventdata, handles)
% hObject    handle to globaldataButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gdata
gdata = handles.data;

filestr = get(handles.currentfile,'String');

rgbvec = [0,0.7,0];

printstr = '================================================================\n';
printstr = [printstr 'Data structure saved to global variable "gdata".\n'];
printstr = [printstr sprintf('Load data with command:\ndata = E200_load_data(''%s'')\n',filestr)];
printstr = [printstr '================================================================\n'];
cprintf(rgbvec,printstr);

% --- Executes on button press in globalhandlesButton.
function globalhandlesButton_Callback(hObject, eventdata, handles)
% hObject    handle to globalhandlesButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% If "handles" is already global,
% this may overwrite handles with the global value.
temp = handles;
global handles
handles = temp;

rgbvec = [0,0.7,0];

printstr = '================================================================\n';
printstr = [printstr 'Handles structure saved to global variable "handles".\n'];
printstr = [printstr '================================================================\n'];
cprintf(rgbvec,printstr)



function imagesliderText_Callback(hObject, eventdata, handles)
% hObject    handle to imagesliderText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of imagesliderText as text
%        str2double(get(hObject,'String')) returns contents of imagesliderText as a double

value = str2double(get(hObject,'String'))
setslider(value,handles.imageslider,handles.imagesliderText);

plotpanel(hObject,handles);

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



function MincountsText_Callback(hObject, eventdata, handles)
% hObject    handle to MincountsText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MincountsText as text
%        str2double(get(hObject,'String')) returns contents of MincountsText as a double

value = str2double(get(hObject,'String'));
setslider(value,handles.Mincounts,handles.MincountsText);

fix_max_min_values('max',handles);

plotpanel(hObject,handles);

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

function MaxcountsText_Callback(hObject, eventdata, handles)
% hObject    handle to MaxcountsText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MaxcountsText as text
%        str2double(get(hObject,'String')) returns contents of MaxcountsText as a double

value = str2double(get(hObject,'String'));
setslider(value,handles.Maxcounts,handles.MaxcountsText);

fix_max_min_values('min',handles);

plotpanel(hObject,handles);

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

% --- Executes on button press in zoombox.
function zoombox_Callback(hObject, eventdata, handles)
% hObject    handle to zoombox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of zoombox

plotpanel(hObject,handles);

if get(handles.zoombox,'Value')
	roixnp = handles.imgstruct.ROI_XNP(imgnum);
	roiynp = handles.imgstruct.ROI_YNP(imgnum);
	if roixnp == 0 || roiynp == 0
		warning(['ROI not valid! ROI_XNP=' num2str(roixnp) ' ROI_YNP=' num2str(roiynp)]);
	else
		set(gca,'XLim',0.5+handles.imgstruct.ROI_X(imgnum)+[0, handles.imgstruct.ROI_XNP(imgnum)]);
		set(gca,'YLim',0.5+handles.imgstruct.ROI_Y(imgnum)+[0, handles.imgstruct.ROI_YNP(imgnum)]);
	end
end


% --------------------------------------------------------------------
function toolbarsave_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toolbarsave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function printbutton_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to printbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in print2elog.
function print2elog_Callback(hObject, eventdata, handles)
% hObject    handle to print2elog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fig=figure();
ax=axes();
[img,imgnum]=img2plot(handles);

xlim_main=get(handles.fig1,'XLim');
ylim_main=get(handles.fig1,'YLim');
set(ax,'XLim',xlim_main);
set(ax,'YLim',ylim_main);

prompt    = {'Title','X Label','Y Label','Elog Title','Comment to Print'};
dlg_title = 'Plot Details';
num_lines = [1,30;1,20;1,20;1,30;10,50];

[temp,camname] = get_imgstruct(handles);
comment        = get(handles.Comment,'String');
comment = flattenstringrows(comment);
dataset        = handles.data.raw.metadata.param.dat{1}.save_name;
comment2print  = sprintf(['Dataset: ' dataset '\n' comment]);
def            = {camname,'','',['DRT Data from ' camname],comment2print};

result=inputdlg(prompt,dlg_title,num_lines,def);
comment2print = flattenstringrows(result{5})
% comment2print = cellstr(result{5});
% temp = ''
% for i=1:numel(comment2print)-1
%         temp = [temp comment2print{i} '\n'];
% end
% temp = [temp comment2print{end}];
% comment2print=temp;

addlabels(result{2},result{3},result{1});

printans=questdlg(sprintf(['Comment: \n\n' comment2print '\n\nPrint to Elog?']),'Final Confirmation','Yes','No','No');
if strcmp(printans,'Yes')
	authstr=handles.data.raw.metadata.param.dat{1}.experiment;
	util_printLog(fig,'title',result{4},'text',sprintf(comment2print),'author',authstr);
end



function expstrbox_Callback(hObject, eventdata, handles)
% hObject    handle to expstrbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of expstrbox as text
%        str2double(get(hObject,'String')) returns contents of expstrbox as a double


% --- Executes during object creation, after setting all properties.
function expstrbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to expstrbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


