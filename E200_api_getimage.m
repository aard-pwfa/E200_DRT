function img = E200_api_getimage(varargin)
	if nargin==1
		handles=varargin{1};
	else
		h = msgbox('Click global handles button.');
		global handles
	end
	imgnum=int32(get(handles.imageslider,'Value'));
	img=handles.images{imgnum};
	img=rot90(img);
end
