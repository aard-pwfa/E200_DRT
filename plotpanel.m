function handles=plotpanel(hObject,handles)

step=int32(get(handles.Stepnumberslider,'Value'));
shot=int32(get(handles.Shotnumberslider,'Value'));

axes(handles.fig1);

if ~strcmp(get(hObject,'tag'),'Shotnumberslider')
	handles=subbgs(hObject,handles);
	handles=checkmaxcounts(handles);
	guidata(hObject,handles);
end

if get(handles.Usebg,'Value')
	imagesc(handles.subimages(:,:,shot),[0,int32(get(handles.Maxcounts,'Value'))]);
else
	imagesc(handles.images(:,:,shot),[0,int32(get(handles.Maxcounts,'Value'))]);
end


end

function handles=subbgs(hObject,handles)

selstr=getlistsel(handles.Cams);

if get(handles.Usebg,'Value')
	if isstruct(handles.cam_back)
		display('here');
		%display(handles.maxsubpixel);
		if ~isfield(handles,'maxsubpixel')
			display('Subtracting backgrounds...');
			handles.subimages=handles.images;
			for i=1:handles.param.n_shot
				handles.subimages(:,:,i) = handles.images(:,:,i)-uint16(handles.cam_back.(selstr).img);
			end
			handles.maxsubpixel=max(handles.subimages(:));
			display('Finished subtracting backgrounds.');
		end
	else
		warndlg('NO BACKGROUNDS SAVED!!!  UNCHECK "USE BG" AT BOTTOM OF GUI!!!');
		error('NO BACKGROUNDS SAVED!!!  UNCHECK "USE BG" AT BOTTOM OF GUI!!!');
	end
end

guidata(hObject,handles);

end

function handles=checkmaxcounts(handles)

if get(handles.Usebg,'Value')
	wantedmax=handles.maxsubpixel;
else
	wantedmax=handles.maxrawpixel;
end

% display(get(handles.Maxcounts,'Value'))
if get(handles.Maxcounts,'Max') ~= wantedmax
	set(handles.Maxcounts,'Max',wantedmax);
	if get(handles.Maxcounts,'Value') > wantedmax
		set(handles.Maxcounts,'Value',wantedmax);
	end
	set(handles.Maxcounts,'SliderStep',[1/wantedmax,10/wantedmax])
	set(handles.Maxcounts,'Enable','on');
end

end
