function handles = plotquiver(handles)
	data    = handles.handles_main.data;
	raw     = data.raw;
	scalars = raw.scalars;
	% ====================================
	% Get selected bsa names
	% ====================================
	dim1 = get(handles.dim1,'Value');
	dim2 = get(handles.dim2,'Value');

	bsa_name_dim1 = handles.bsa_str{dim1};
	bsa_name_dim2 = handles.bsa_str{dim2};

	bsa_str1 = scalars.(bsa_name_dim1);
	bsa_str2 = scalars.(bsa_name_dim2);

	% ====================================
	% Get step values
	% ====================================
	step_value_str1 = scalars.step_value_dim1;
	step_value_str2 = scalars.step_value_dim2;

	% ====================================
	% Get step numbers
	% ====================================
	step_num_str1 = scalars.step_num_dim1;
	step_num_str2 = scalars.step_num_dim2;

	% ====================================
	% Iterate over steps
	% ====================================
	n_step_dim1 = length(unique(step_num_str1.dat));
	n_step_dim2 = length(unique(step_num_str2.dat));
	n_steps = n_step_dim1*n_step_dim2;

	x_array = zeros(1,n_steps);
	y_array = zeros(1,n_steps);
	u_array = zeros(1,n_steps);
	v_array = zeros(1,n_steps);
	for i = 1:n_step_dim1
		for j = 1:n_step_dim2
			ind = (i-1)*n_step_dim1 + j;
			% ====================================
			% Get bsa data for x,y
			% ====================================
			uids_x = E200_api_getUID(step_num_str1,i);
			uids_y = E200_api_getUID(step_num_str2,j);
            
            uids = intersect(uids_x,uids_y);

			vals_x = E200_api_getdat(bsa_str1,uids);
			vals_y = E200_api_getdat(bsa_str2,uids);

			u_array(ind) = mean(vals_x);
			v_array(ind) = mean(vals_y);

			% ====================================
			% Get step value
			% ====================================
			x_array(ind) = E200_api_getdat(step_value_str1,uids_x(1));
			y_array(ind) = E200_api_getdat(step_value_str2,uids_y(1));
		end
	end

	quiver(x_array,y_array,u_array,v_array);
end
