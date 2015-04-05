function handles=corrplot(hObject,handles)
	
	x_scal_ind=get(handles.Xcorrpopup,'Value');
	y_scal_ind=get(handles.Ycorrpopup,'Value');

	x_scal_name=handles.corr_settings{x_scal_ind,1};
	y_scal_name=handles.corr_settings{y_scal_ind,1};

	x_type = handles.corr_settings{x_scal_ind,2};
	y_type = handles.corr_settings{y_scal_ind,2};

	x=get_scalar_struct(x_scal_ind,x_type,x_scal_name,handles);
	y=get_scalar_struct(y_scal_ind,y_type,y_scal_name,handles);

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
	fig=figure;
	plot(x.dat,y.dat);
	xlabel(x_scal_name,'Interpreter','none');
	ylabel(y_scal_name,'Interpreter','none');

	printfig2elog(fig,handles.data,'correlation plot');
end

function out=get_scalar_struct(ind,type,name,handles)
	if ind==1
		names=fieldnames(handles.data.raw.scalars);
		out.UID=handles.data.raw.scalars.(names{1}).UID;
		out.dat=[1:size(out.UID,2)];
	else
		out.UID=handles.data.(type).scalars.(name).UID;
		out.dat=handles.data.(type).scalars.(name).dat;
	end
end

