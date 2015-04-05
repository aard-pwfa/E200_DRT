function handles=corrplot(handles)
	
	y_scal_ind  = get(handles.Ycorrpopup,'Value');
	y_scal_name = handles.corr_settings{y_scal_ind,1};
	y_type      = handles.corr_settings{y_scal_ind,2};

	y=get_scalar_struct(y_scal_ind,y_type,y_scal_name,handles);

	% Split into steps
	step_num_str = handles.data.raw.scalars.step_num;
	step_val_str = handles.data.raw.scalars.step_value;

	step_num = E200_api_getdat(step_num_str,y.UID);
	step_num = unique(step_num);
	
	num_steps = length(step_num);

	step_val = zeros(num_steps);
	y_avg    = zeros(num_steps);
	y_std    = zeros(num_steps);

	for i=step_num
		step_uids = E200_api_getUID(step_num_str,i);
		step_val(i) = E200_api_getdat(step_val_str,step_uids(1));
		y_vals  = E200_api_getdat(y,step_uids);
		y_avg(i) = mean(y_vals);
		y_std(i) = std(y_vals);
	end

	% axes(handles.fig1);
	fig = figure;
	errorbar(step_val,y_avg,y_std);
	xlabel('Step Value','Interpreter','none');
	ylabel(y_scal_name,'Interpreter','none');

	printfig2elog(fig,handles.data,'step correlation plot');

end

function out=get_scalar_struct(ind,type,name,handles)
	out = handles.data.(type).scalars.(name);
end

