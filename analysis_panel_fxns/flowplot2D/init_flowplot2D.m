function handles = init(handles,varargin_main)
	global myhl
	handles.handles_main = varargin_main{1};

	bsa_str = fieldnames(handles.handles_main.data.raw.scalars);

	set(handles.dim1,'String',bsa_str);
	set(handles.dim2,'String',bsa_str);
	handles.bsa_str = bsa_str;
	myhl = handles;
end
