function handles=plotpanel(hObject,handles)
	data = handles.data;
	axes(handles.fig1);
	
	imgnum=int32(get(handles.imageslider,'Value'));
	maxval=int32(get(handles.Maxcounts,'Value'));
	minval=int32(get(handles.Mincounts,'Value'));

	% display(maxval)

	cmap=custom_cmap();
	colormap(cmap.wbgyr);

	% img=handles.images{imgnum}-uint16(handles.images_bg{imgnum});
	img=handles.images{imgnum};
	img=rot90(img);
	% % img=fliplr(img);
	% img=log10(double(img));
	% display(max(max(img)));

	if minval == 0
		minval = 0.5;
	end
	% imagesc(img,[log10(double(minval)),log10(double(maxval))]);
	imagesc(img,[double(minval),double(maxval)]);
	colorbar
	
	contents = cellstr(get(handles.xunits,'String'));
	xunitsStr = contents{get(handles.xunits,'Value')};
	switch xunitsStr
	case 'Millimeters'
		imgstruct = get_imgstruct(handles);
		res = imgstruct.RESOLUTION(imgnum);
		[ysize,xsize] = size(img);
		xmean = xsize/2;
		xticks = 0:xsize/5:xsize;
		xticklabels = (-xmean*res:xsize*res/5:xmean*res)/10^3;
		xticklabelstr = {};
		for i=1:size(xticklabels,2)
			xticklabelstr = [xticklabelstr sprintf('%03.2f',xticklabels(i))];
		end
		% display(xticklabels)
		% display(xticklabelstr)
		set(handles.fig1,'XTick',xticks);
		set(handles.fig1,'XTickLabel',xticklabelstr);
	case 'Energy'
		% img;
		% Determine spectrometer bend settings/calibration
		bend_struct = data.raw.scalars.LI20_LGPS_3330_BDES;
		% bool        = ismember(wanted_UIDs,bend_struct.UID);
		% display(bend_struct.UID)
		B5D36 = bend_struct.dat{1};
		
		% Get imgstruct for current options.
		camind    = get(handles.Cams,'Value');
		datatype  = handles.CamsLookup.datatype{camind};
		name      = handles.CamsLookup.name{camind};

		e_axis=E200_cher_get_E_axis('20131125',name,0,[1:1392],0,B5D36);

		[ysize,xsize] = size(img);
		
		xticks = 0:xsize/5:xsize;
		xticklabels = e_axis(xticks+1);
		xticklabelstr = {};
		for i=1:size(xticklabels,2)
			xticklabelstr = [xticklabelstr sprintf('%03.2f',xticklabels(i))];
		end
		set(handles.fig1,'XTick',xticks);
		set(handles.fig1,'XTickLabel',xticklabelstr);

		% [Erange, Eres, Dy] = E200_cher_get_E_axis(datename, camname, visu,  pixelrange, offset, sbend_setting)
	end
	
	contents = cellstr(get(handles.yunits,'String'));
	yunitsStr = contents{get(handles.yunits,'Value')};
	switch yunitsStr
	case 'Millimeters'
		imgstruct = get_imgstruct(handles);
		res = imgstruct.RESOLUTION(imgnum);
		[ysize,xsize] = size(img);
		ymean = ysize/2;
		yticks = 0:ysize/5:ysize;
		yticklabels = (-ymean*res:ysize*res/5:ymean*res)/10^3;
		yticklabelstr = {};
		for i=1:size(yticklabels,2)
			yticklabelstr = [yticklabelstr sprintf('%03.2f',yticklabels(i))];
		end
		% display(yticklabels)
		% display(yticklabelstr)
		set(handles.fig1,'YTick',yticks);
		set(handles.fig1,'YTickLabel',yticklabelstr);
	end
end
