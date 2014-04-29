function [img,imgnum]=img2plot(handles)
	imgnum=int32(get(handles.imageslider,'Value'));
	maxval=int32(get(handles.Maxcounts,'Value'));
	minval=int32(get(handles.Mincounts,'Value'));

	% display(maxval)

	cmap=custom_cmap();
	colormap(cmap.wbgyr);

	img=handles.images{imgnum};

	if minval == 0
		minval = 0.5;
	end
	imagesc(img,[double(minval),double(maxval)]);
	colorbar

end
