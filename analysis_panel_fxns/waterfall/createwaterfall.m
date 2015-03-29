function handles=createwaterfall(handles)
	global ghandles;

	imgstr=handles.handles_main.data.raw.images.(handles.handles_main.camname);
	handles.uids = imgstr.UID;
	handles.numimgs=length(handles.uids);
	
	display(['Processing ' num2str(handles.numimgs) ' into waterfall...']);
	% ====================================
	% Set rotation variables
	% ====================================
	if get(handles.rotation,'Value')
		vertical_bool = true;
		sum_dimension = 2;
		arraysize = handles.roi.maxy-handles.roi.miny+1;
	else
		vertical_bool = false;
		sum_dimension = 1;
		arraysize = handles.roi.maxx-handles.roi.minx+1;
	end

	% ====================================
	% Create array
	% ====================================
	waterarray=zeros(handles.numimgs,arraysize);
	for i=1:handles.numimgs
		if mod(i,10)==0
			display(['Image number ' num2str(i)]);
		end
		images=E200_load_images(imgstr,handles.uids(i));
		images=images{1};
		subimg=images(handles.roi.miny:handles.roi.maxy,handles.roi.minx:handles.roi.maxx);
		subimg=sum(subimg,sum_dimension);
		waterarray(i,:)=subimg;
	end

	% ====================================
	% Rotate if requested
	% ====================================
	if vertical_bool
		waterarray=rot90(waterarray,-1);
	end

	handles.waterarray_unsort=waterarray;

	% % ====================================
	% % Sort if requested
	% % ====================================
	% sortvarind=get(handles.sortvar,'Value');
	% % display(sortvarind)
	% settings=handles.sort_settings;
	% scalarname = settings{sortvarind,1};
	% if sortvarind~=1
	% 	type = settings{sortvarind,2};
	% 	% display(scalarname)
	% 	scalarstr=handles.handles_main.data.(type).scalars.(scalarname);
	% 	% dat=E200_api_getdat(scalarstr,imgstr.UID)
	% 	[dat,scalarind,imgind]=intersect(scalarstr.UID,uids);
	% 	scalar_dat_intersect = scalarstr.dat(scalarind);
	% 	[scalar_dat_sort,sortind]=sort(scalar_dat_intersect);
	% 	if get(handles.rotation,'Value')
	% 		waterarray = waterarray(:,sortind);
	% 	else
	% 		waterarray = waterarray(sortind,:);
	% 	end
	% else
	% 	scalar_dat_sort = 1:length(uids);
	% end

	% handles.sort_scalarname = scalarname;
	% handles.sort_scalar_dat=scalar_dat_sort;
	% handles.waterarray = waterarray;
	
	% maxcounts = max(max(waterarray));
	% set(handles.Maxcounts,'Max',maxcounts);
	% set(handles.Maxcounts,'Value',maxcounts);
	% set(handles.Maxcounts,'SliderStep',[0.01,0.1]);

	% set(handles.Mincounts,'Max',maxcounts-1);
	% set(handles.Mincounts,'Value',0);
	% set(handles.Mincounts,'SliderStep',[0.01,0.1]);


	% % figure;
	% plotoutput(handles.output_axes,handles);
	% plot_sort(handles,handles.sort_axes);

	% display('Finished!');
	handles = finishwaterfall(handles);

	ghandles = handles;
end
