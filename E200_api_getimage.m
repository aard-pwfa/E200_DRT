function img = E200_api_getimage()
	h = msgbox('Click global handles button.');
	global handles
	imgnum=int32(get(handles.imageslider,'Value'));
	img=handles.images{imgnum};
	img=rot90(img);
end
