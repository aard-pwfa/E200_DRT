function handles=init(handles,varargin_main)
	handles.handles_main = varargin_main{1};

	num_img=size(handles.handles_main.images,2);
	set(handles.imageslider,'Min',1);
	set(handles.imageslider,'Max',num_img);
	set(handles.imageslider,'Value',handles.handles_main.imgnum);
	set(handles.imageslider,'SliderStep',[1/(num_img-1),10/(num_img-1)])

	set(handles.Maxcounts,'Min',1);
	set(handles.Maxcounts,'Max',2);
	set(handles.Maxcounts,'Value',2);
	set(handles.Maxcounts,'SliderStep',[1,10]);

	set(handles.Mincounts,'Min',0);
	set(handles.Mincounts,'Max',1);
	set(handles.Mincounts,'Value',0);
	set(handles.Mincounts,'SliderStep',[1,10]);

	plotpreview(handles);
end
