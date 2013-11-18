function handles=plotpanel(hObject,handles)
	global phandles
	phandles = handles
	
	% step=int32(get(handles.Stepnumberslider,'Value'));
	% shot=int32(get(handles.Shotnumberslider,'Value'));
	
	axes(handles.fig1);
	
	imgnum=int32(get(handles.imageslider,'Value'));
	maxval=int32(get(handles.Maxcounts,'Value'));
	minval=int32(get(handles.Mincounts,'Value'));

	display(maxval)

	cmap=custom_cmap();
	colormap(cmap.wbgyr);

	% img=handles.images{imgnum}-uint16(handles.images_bg{imgnum});
	img=handles.images{imgnum};
	img=rot90(img);
	% % img=fliplr(img);
	img=log10(double(img));
	display(max(max(img)));

	if minval == 0
		minval = 0.5;
	end
	imagesc(img,[log10(double(minval)),log10(double(maxval))]);
	colorbar
	
	switch handles.xunits
	case 'Millimeters'
		imgstruct = get_imgstruct(handles);
		res = imgstruct.RESOLUTION(imgnum);
		[xsize,ysize] = size(img);
		xmean = xsize/2;
		xticks = 0:xsize/5:xsize;
		xticklabels = (-xmean*res:xsize*res/5:xmean*res)/10^4;
		xticklabelstr = {};
		for i=1:size(xticklabels,2)
			xticklabelstr = [xticklabelstr sprintf('%03.2f',xticklabels(i))];
		end
		display(xticklabels)
		display(xticklabelstr)
		set(handles.fig1,'XTick',xticks)
		set(handles.fig1,'XTickLabel',xticklabelstr)
	end
	
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

<<<<<<< HEAD
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
=======
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
>>>>>>> fs20_datastruct

end

function handles=checkmaxcounts(handles)

<<<<<<< HEAD
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
=======
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
		% set(handles.Maxcounts,'SliderStep',[1/wantedmax,10/wantedmax]);
		set(handles.Maxcounts,'Enable','on');
	end
	
end
>>>>>>> fs20_datastruct
