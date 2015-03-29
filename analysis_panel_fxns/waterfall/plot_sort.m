function plot_sort(handles,ax)
	sortvarind=get(handles.sortvar,'Value');
	if sortvarind == 1
		name='Shot (As Taken)';
		values=1:handles.numimgs;
	else
		name=handles.sort_scalarname;
		values=handles.sort_scalar_dat;
	end

	axes(ax);

	plot(values);
	addlabels('Shot (sorted)',name,'');
end
