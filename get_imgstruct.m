function [imgstruct,varargout]=get_imgstruct(handles)
	% Get imgstruct for current options.
	camind    = get(handles.Cams,'Value');
	datatype  = handles.CamsLookup.datatype{camind};
	name      = handles.CamsLookup.name{camind};
	imgstruct = handles.data.(datatype).images.(name);
	varargout{1}=name;
end
