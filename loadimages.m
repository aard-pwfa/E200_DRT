function handles=loadimages(hObject,handles)
global gl

% Disable things while loading
cla(handles.fig1);
set(handles.Stepnumberslider,'Enable','off');
set(handles.Stepnumbertext,'Enable','off');
set(handles.Shotnumberslider,'Enable','off');
set(handles.Shotnumbertext,'String','');
set(handles.Shotnumbertext,'Enable','off');
set(handles.Maxcounts,'Enable','off');

% Make things cleaner
data=handles.data;

camind=get(hObject,'Value');
datatype=handles.CamsLookup.datatype{camind};
name=handles.CamsLookup.name{camind};
imgstruct=data.(datatype).images.(name);

allsteps=get(handles.allsteps,'Value');
allshots=get(handles.allshots,'Value');

% Use all steps
if allsteps
	wanted_UID_step=data.raw.scalars.step_num.UID;
else
	stepval=get(handles.Stepnumberslider,'Value');
	bool=(data.raw.scalars.step_num.dat==stepval);
	wanted_UID_step=data.raw.scalars.step_num.UID(bool);
end

display(['Loading images, expect ' num2str(handles.data.raw.metadata.param.dat{1}.n_shot*15/100) ' second wait...']);
handles.images=E200_load_images(imgstruct,wanted_UID_step);
num_img=size(handles.images,2);
imagesc(handles.images{get(handles.imageslider,'Value')});
% imagesc(

handles.maxrawpixel=maxpixel(handles.images);
set(handles.Maxcounts,'Max',handles.maxrawpixel);
set(handles.Maxcounts,'Value',handles.maxrawpixel);
set(handles.Maxcounts,'SliderStep',[1/(handles.maxrawpixel-1),10/(handles.maxrawpixel-1)])
set(handles.Maxcounts,'Enable','on');
set(handles.Shotnumberslider,'Enable','on');
set(handles.Shotnumberslider,'Value',1);
set(handles.Shotnumbertext,'String','1');
set(handles.Shotnumbertext,'Enable','on');

set(handles.Stepnumberslider,'Enable','on');
set(handles.Stepnumbertext,'Enable','on');

set(handles.imageslider,'Enable','On');
set(handles.imageslider,'Max',num_img);
% set(handles.imageslider,'Value',1);
set(handles.imageslider,'SliderStep',[1/(num_img-1),10/(num_img-1)])

% set(handles.Maxcounts,'Max',handles.maxrawpixel);
% set(handles.Maxcounts,'Value',handles.maxrawpixel);
% set(handles.Maxcounts,'SliderStep',[1/handles.maxrawpixel,10/handles.maxrawpixel]);
% set(handles.Maxcounts,'Enable','on');
gl.handles=handles;

guidata(hObject,handles);

end

function out=maxpixel(imagecell)
	out=0;
	% display(size(imagecell));
	for i=imagecell
		% display(size(i));
		out=max(out,max(max(i{1})));
	end
	% display(out);
end
