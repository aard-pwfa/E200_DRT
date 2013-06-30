function handles=plotpanel(hObject,handles)

% step=int32(get(handles.Stepnumberslider,'Value'));
% shot=int32(get(handles.Shotnumberslider,'Value'));

axes(handles.fig1);

imgnum=int32(get(handles.imageslider,'Value'));
imagesc(handles.images{imgnum},[0,int32(get(handles.Maxcounts,'Value'))]);


% if ~strcmp(get(hObject,'tag'),'Shotnumberslider')
%	handles=subbgs(hObject,handles);
%	handles=checkmaxcounts(handles);
%	guidata(hObject,handles);
% end

% if get(handles.Usebg,'Value')
%       imagesc(handles.subimages(:,:,shot),[0,int32(get(handles.Maxcounts,'Value'))]);
% else
%       imagesc(handles.images(:,:,shot),[0,int32(get(handles.Maxcounts,'Value'))]);
% end


end

function handles=subbgs(hObject,handles)

selstr=getlistsel(handles.Cams);

% Used to be how we subtract backgrounds.  New approach!
% if get(handles.Usebg,'Value')
%         display('here');
%         if ~isfield(handles,'maxsubpixel')
%                 display('Subtracting backgrounds...');
%                 handles.subimages=handles.images;
%                 for i=1:handles.data.raw.metadata.param.dat{1}.n_shot
%                         handles.subimages(:,:,i) = handles.images(:,:,i)-uint16(handles.data.raw.cam_back.(selstr).img);
%                 end
%                 handles.maxsubpixel=max(handles.subimages(:));
%                 display('Finished subtracting backgrounds.');
%         end
% end

guidata(hObject,handles);

end

function handles=checkmaxcounts(handles)

% No usebg
% if get(handles.Usebg,'Value')
%         wantedmax=handles.maxsubpixel;
% else
%         wantedmax=handles.maxrawpixel;
% end

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
