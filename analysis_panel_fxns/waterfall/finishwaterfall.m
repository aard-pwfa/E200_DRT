function handles = finishwaterfall(handles)
	waterarray_unsort = handles.waterarray_unsort;
	% ====================================
	% Sort if requested
	% ====================================
	sortvarind=get(handles.sortvar,'Value');
	% display(sortvarind)
	settings=handles.sort_settings;
	scalarname = settings{sortvarind,1};
	if sortvarind~=1
		type = settings{sortvarind,2};
		% display(scalarname)
		scalarstr=handles.handles_main.data.(type).scalars.(scalarname);
		% dat=E200_api_getdat(scalarstr,imgstr.UID)
		[dat,scalarind,imgind]=intersect(scalarstr.UID,handles.uids);
		scalar_dat_intersect = scalarstr.dat(scalarind);
		[scalar_dat_sort,sortind]=sort(scalar_dat_intersect);
		if get(handles.rotation,'Value')
			waterarray = waterarray_unsort(:,fliplr(sortind));
		else
			waterarray = waterarray_unsort(sortind,:);
		end
	else
		scalar_dat_sort = 1:length(handles.uids);
		waterarray = fliplr(waterarray_unsort);
	end

	handles.sort_scalarname = scalarname;
	handles.sort_scalar_dat=scalar_dat_sort;
	handles.waterarray = waterarray;
	
	maxcounts = max(max(waterarray));
	set(handles.Maxcounts,'Max',maxcounts);
	set(handles.Maxcounts,'Value',maxcounts);
	set(handles.Maxcounts,'SliderStep',[0.01,0.1]);

	set(handles.Mincounts,'Max',maxcounts-1);
	set(handles.Mincounts,'Value',0);
	set(handles.Mincounts,'SliderStep',[0.01,0.1]);

	% figure;
	plotoutput(handles.output_axes,handles);
	plot_sort(handles,handles.sort_axes);

	display('Finished!');
end
