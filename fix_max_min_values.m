function fix_max_min_values(tofixstr,handles)
	% Get max and min values
	maxval=int32(get(handles.Maxcounts,'Value'));
	minval=int32(get(handles.Mincounts,'Value'));

	switch tofixstr
	case 'min'
		if maxval <= minval
			set(handles.Mincounts,'Value',maxval-1);
			set(handles.MincountsText,'String',num2str(maxval-1));
		end
	case 'max'
		if maxval <= minval
			set(handles.Maxcounts,'Value',minval+1);
			set(handles.MaxcountsText,'String',num2str(minval+1));
		end
	end
end
