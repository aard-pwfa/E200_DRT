function handles = waterfall(handles)
	addpath(fullfile(pwd,'analysis_panel_fxns','waterfall'));
	waterfallGUI(handles);
end

function old()
	% =========================
	% Define ROI
	% =========================
	figure(1);
	% display(handles.imgnum);
	cmap=custom_cmap();
	colormap(cmap.wbgyr);

	imagesc(img);
	% caxis([0 1000]);
	my_roi = ginput(2);
	cmos_roi.top = round(my_roi(1,2));
	cmos_roi.bottom = round(my_roi(2,2));
	cmos_roi.left = round(my_roi(1,1));
	cmos_roi.right = round(my_roi(2,1));
	cmos_roi.rot = 3;
	
	im_struct = handles.data.raw.images.(handles.camname);
	use_bg=true;
	header='';

	IM_ANA = basic_image_ana(im_struct,use_bg,cmos_roi,header)

	cmos_specs = IM_ANA.y_profs;
	
	x_axis = [1:size(IM_ANA.y_profs,2)];
	y_axis = [1:size(IM_ANA.y_profs,1)];
	display(x_axis);
	display(y_axis);
	display(size(IM_ANA.y_profs));

	figure(2); pcolor(x_axis,y_axis,IM_ANA.y_profs); shading flat; box off;

end
