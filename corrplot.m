function handles=corrplot(hObject,handles)
	
	x_scal_ind=get(handles.Xcorrpopup,'Value');
	y_scal_ind=get(handles.Ycorrpopup,'Value');
	x_contents = get(handles.Xcorrpopup,'String');
	x_scal_name=x_contents{x_scal_ind};
	y_contents = get(handles.Ycorrpopup,'String');
	y_scal_name=y_contents{y_scal_ind};

	x=get_scalar_struct(x_scal_ind,x_scal_name,handles);
	y=get_scalar_struct(y_scal_ind,y_scal_name,handles);

	% Get common data
	[vals,ix,iy]=intersect(x.UID,y.UID);
	x.dat=x.dat(ix);
	x.UID=x.UID(ix);
	y.dat=y.dat(iy);
	y.UID=y.UID(iy);

	% Sort on x
	[temp, ix]=sort(x.dat);
	x.dat=x.dat(ix);
	x.UID=x.UID(ix);
	y.dat=y.dat(ix);
	y.UID=y.UID(ix);


	% axes(handles.fig1);
	figure;
	plot(x.dat,y.dat);
	xlabel(x_scal_name,'Interpreter','none');
	ylabel(y_scal_name,'Interpreter','none');

end

function out=get_scalar_struct(ind,name,handles)
	if ind==1
		names=fieldnames(handles.data.raw.scalars);
		out.UID=handles.data.raw.scalars.(names{1}).UID;
		out.dat=[1:size(out.UID,2)];
	else
		out.UID=handles.data.raw.scalars.(name).UID;
		out.dat=handles.data.raw.scalars.(name).dat;
	end
end

