function [img,imgnum]=img2plot(handles)
	imgnum=int32(get(handles.imageslider,'Value'));
	maxval=int32(get(handles.Maxcounts,'Value'));
	minval=int32(get(handles.Mincounts,'Value'));

	% display(maxval)

	cmap=custom_cmap();
	colormap(cmap.wbgyr);

	% img=handles.images{imgnum}-uint16(handles.images_bg{imgnum});
	img=handles.images{imgnum};
	% img=rot90(img);
	% % img=fliplr(img);
	% img=log10(double(img));
	% display(max(max(img)));

	if minval == 0
		minval = 0.5;
	end
	% imagesc(img,[log10(double(minval)),log10(double(maxval))]);
	if handles.imgstruct.X_ORIENT(imgnum)
		img=fliplr(img);
	end
	if handles.imgstruct.Y_ORIENT(imgnum)
		img=flipud(img);
	end
	imagesc(img,[double(minval),double(maxval)]);
	colorbar
end
