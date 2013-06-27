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

display(['Loading images, expect ' num2str(handles.param.n_shot*15/100) ' second wait...']);
switch handles.settype
    case 'scan'
        handles.images=E200_readImages(handles.scan.scan_info(step).(selstr));
    case 'daq'
        handles.images = E200_readImages(handles.daq.filenames.(selstr));
        set(handles.Stepnumbertext,'String','N/A');
    otherwise
        error('No images loaded!');
end

handles.maxrawpixel=max(handles.images(:));
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