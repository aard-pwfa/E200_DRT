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
	case 'Energy'
		img
	% Determine spectrometer bend settings/calibration
	bend_struct = data.raw.scalars.LI20_LGPS_3330_BDES;
	bool        = ismember(wanted_UIDs,bend_struct.UID);
	% display(bend_struct.UID)
	B5D36 = bend_struct.dat{1};
	% display(B5D36);
	e_axis=E200_cher_get_E_axis('20130423','CELOSS',0,[1:1392],0,B5D36);
		
		[Erange, Eres, Dy] = E200_cher_get_E_axis(datename, camname, visu,  pixelrange, offset, sbend_setting)
	end
	
	switch handles.yunits
	case 'Millimeters'
		imgstruct = get_imgstruct(handles);
		res = imgstruct.RESOLUTION(imgnum);
		[xsize,ysize] = size(img);
		ymean = ysize/2;
		yticks = 0:ysize/5:ysize;
		yticklabels = (-ymean*res:ysize*res/5:ymean*res)/10^4;
		yticklabelstr = {};
		for i=1:size(yticklabels,2)
			yticklabelstr = [yticklabelstr sprintf('%03.2f',yticklabels(i))];
		end
		display(yticklabels)
		display(yticklabelstr)
		set(handles.fig1,'YTick',yticks)
		set(handles.fig1,'YTickLabel',yticklabelstr)
	end
end

function handles=subbgs(hObject,handles)

	selstr=getlistsel(handles.Cams);
	
	guidata(hObject,handles);

end

function handles=checkmaxcounts(handles)
	if get(handles.Maxcounts,'Max') ~= wantedmax
		set(handles.Maxcounts,'Max',wantedmax);
		if get(handles.Maxcounts,'Value') > wantedmax
			set(handles.Maxcounts,'Value',wantedmax);
		end
		% set(handles.Maxcounts,'SliderStep',[1/wantedmax,10/wantedmax]);
		set(handles.Maxcounts,'Enable','on');
	end
	
end
