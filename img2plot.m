function [img,imgnum]=img2plot(handles)
	imgnum=int32(get(handles.imageslider,'Value'));
	maxval=int32(get(handles.Maxcounts,'Value'));
	minval=int32(get(handles.Mincounts,'Value'));

	% display(maxval)

	cmap=custom_cmap();
	colormap(cmap.wbgyr);

	[img,img_bg] = E200_load_images(handles.imgstruct,handles.wanted_UID_step(imgnum));
	img = img{1}-uint16(img_bg{1});

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
