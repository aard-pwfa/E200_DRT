function handles=loadimages(hObject,handles)

% Disable things while loading
cla(handles.fig1);
set(handles.Stepnumberslider,'Enable','off');
set(handles.Stepnumbertext,'Enable','off');
set(handles.Shotnumberslider,'Enable','off');
set(handles.Shotnumbertext,'String','');
set(handles.Shotnumbertext,'Enable','off');
set(handles.Maxcounts,'Enable','off');
set(handles.Usebg,'Enable','off');

step=int32(get(handles.Stepnumberslider,'Value'));

selstr=getlistsel(handles.Cams);

display(['Loading images, expect ' num2str(handles.data.raw.metadata.param.dat{1}.n_shot*15/100) ' second wait...']);

handles.maxrawpixel=maxpixel(handles.images);
set(handles.Maxcounts,'Max',handles.maxrawpixel);
set(handles.Maxcounts,'Value',handles.maxrawpixel);
set(handles.Maxcounts,'SliderStep',[1/handles.maxrawpixel,10/handles.maxrawpixel])
set(handles.Maxcounts,'Enable','on');
set(handles.Shotnumberslider,'Enable','on');
set(handles.Shotnumberslider,'Value',1);
set(handles.Shotnumbertext,'String','1');
set(handles.Shotnumbertext,'Enable','on');

set(handles.Stepnumberslider,'Enable','on');
set(handles.Stepnumbertext,'Enable','on');

set(handles.Usebg,'Enable','on');

% set(handles.Maxcounts,'Max',handles.maxrawpixel);
% set(handles.Maxcounts,'Value',handles.maxrawpixel);
% set(handles.Maxcounts,'SliderStep',[1/handles.maxrawpixel,10/handles.maxrawpixel]);
% set(handles.Maxcounts,'Enable','on');


guidata(hObject,handles);

end

function out=maxpixel(imagecell)
	out=0;
	display(size(imagecell));
	for i=imagecell
		display(size(i));
		out=max(out,max(max(i{1})));
	end
	display(out);
end
