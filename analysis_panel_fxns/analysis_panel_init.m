function analysis_panel_init(hObject,handles)
	% display(handles)
	analysis_struct = analysis_info();
	str_cell = {};
	for i = 1:length(analysis_struct)
		str_cell = [str_cell, analysis_struct(i).str];
	set(hObject,'String',str_cell)
end
