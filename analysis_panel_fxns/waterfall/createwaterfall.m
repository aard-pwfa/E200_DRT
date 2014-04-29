function handles=createwaterfall(handles)
	display('starting');
	display(get(handles.rotation,'Value'));
	if get(handles.rotation,'Value')
		vertical_bool = true;
		sum_dimension = 2;
		arraysize = handles.roi.maxy-handles.roi.miny+1;
	else
		vertical_bool = false;
		sum_dimension = 1;
		arraysize = handles.roi.maxx-handles.roi.minx+1;
	end
	imgstr=handles.handles_main.data.raw.images.(handles.handles_main.camname);
	numimgs=length(imgstr.UID);
	% subimg=images(handles.roi.miny:handles.roi.maxy,handles.roi.minx:handles.roi.maxx);
	waterarray=zeros(numimgs,arraysize);
	% size(waterarray)

	for i=1:numimgs
		if mod(i,10)==0
			display(['Image number ' num2str(i)]);
		end
		% display(i);
		images=E200_load_images(imgstr,imgstr.UID(i));
		% images=rot90(images{1},2);
		images=images{1};
		subimg=images(handles.roi.miny:handles.roi.maxy,handles.roi.minx:handles.roi.maxx);
		% figure;
		% imagesc(subimg);
		% pause;
		subimg=sum(subimg,sum_dimension);
		% if sum_dimension==2
		%         subimg=transpose(subimg)
		% end
		% size(subimg)
		waterarray(i,:)=subimg;
	end
	if vertical_bool
		waterarray=rot90(waterarray,-1);
	end
	handles.waterarray = waterarray;
	maxcounts = max(max(waterarray));
	set(handles.Maxcounts,'Max',maxcounts);
	set(handles.Maxcounts,'Value',maxcounts);
	set(handles.Maxcounts,'SliderStep',[0.01,0.1])

	set(handles.Mincounts,'Max',maxcounts-1);
	set(handles.Mincounts,'Value',0);
	set(handles.Mincounts,'SliderStep',[0.01,0.1])

	% figure;
	plotoutput(handles);
	display('finishing');
end
