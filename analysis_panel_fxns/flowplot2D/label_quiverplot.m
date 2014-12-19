function [title,xlabel,ylabel] = label_quiverplot(handles)
	title = 'Quiver Plot';
	
	% ====================================
	% Get selected bsa names
	% ====================================
	dim1 = get(handles.dim1,'Value');
	dim2 = get(handles.dim2,'Value');
	
	bsa_name_dim1 = handles.bsa_str{dim1};
	bsa_name_dim2 = handles.bsa_str{dim2};
	
	xlabel = bsa_name_dim1;
	ylabel = bsa_name_dim2;

	addlabels(xlabel,ylabel,title);

end
