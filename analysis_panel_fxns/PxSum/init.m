function handles=init(handles,varargin_main)
	handles.handles_main = varargin_main{1};
	handles.hObject_main = varargin_main{2};

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

	sort_str_raw=fieldnames(handles.handles_main.data.raw.scalars);
	sort_str_proc = fieldnames(handles.handles_main.data.processed.scalars);
	% First is special: just use index.
	sort_settings = {{'As taken'},{'NA'}};

	for i=1:length(sort_str_raw)
		sort_settings = [sort_settings;{sort_str_raw{i},'raw'}];
	end
	for i=1:length(sort_str_proc)
		sort_settings = [sort_settings;{sort_str_proc{i},'processed'}];
	end

	sort_array = {};

	for i=1:length(sort_settings)
		sort_array = [sort_array;sort_settings{i,1}];
	end

	% set(handles.sortvar,'String',sort_array);
	handles.sort_settings=sort_settings;

	plotpreview(handles);
end
