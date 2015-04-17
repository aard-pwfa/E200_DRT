function handles=createwaterfall(handles)
	global ghandles;

	camname = handles.handles_main.camname;
	imgstr=handles.handles_main.data.raw.images.(camname);
	handles.uids = imgstr.UID;
	handles.numimgs=length(handles.uids);
	
	display(['Processing ' num2str(handles.numimgs) ' into waterfall...']);

	pxsum_name=[camname '_pxsum'];
	data.processed.scalars.(pxsum_name).UID = [];
	data.processed.scalars.(pxsum_name).dat = [];
	data.processed.scalars.(pxsum_name).desc = 'Interaction strength based on summing';
	InteractionStrength = data.processed.scalars.(pxsum_name);

	% ====================================
	% Create array
	% ====================================
	% for i=1:handles.numimgs
	for i=handles.uids
		if mod(i,10)==0
			display(['Image number ' num2str(i)]);
		end

		images=E200_load_images(imgstr,i);
		images=images{1};
		subimg=images(handles.roi.miny:handles.roi.maxy,handles.roi.minx:handles.roi.maxx);
		
		InteractionStrength.UID = [InteractionStrength.UID, i];
		InteractionStrength.dat = [InteractionStrength.dat, sum(sum(subimg))];
	end

	data.processed.scalars.(pxsum_name) = InteractionStrength;
	handles.data=data;

	handles.handles_main.data=data;

	ghandles = handles;
	guidata(handles.hObject_main, handles.handles_main);
end
