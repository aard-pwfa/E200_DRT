function openfig(handles)
	img = E200_api_getimage(handles);
	maxval=int32(get(handles.Maxcounts,'Value'));
	minval=int32(get(handles.Mincounts,'Value'));

	% display(maxval)

	cmap=custom_cmap();
	colormap(cmap.wbgyr);

	if minval == 0
		minval = 0.5;
	end

	display('here')
	figure();
	imagesc(img,[double(minval),double(maxval)]);
	colorbar
end
