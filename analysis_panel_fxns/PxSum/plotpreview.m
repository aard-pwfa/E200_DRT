function plotpreview(handles)
	% =============================
	% Get requested image number
	% =============================
	imgnum = get(handles.imageslider,'Value');

	% =============================
	% Plot image
	% =============================
	axes(handles.preview_axes);
	btnfcn = get(handles.preview_axes,'Buttondownfcn');
	img    = handles.handles_main.images{imgnum};
	imagesc(img,'HitTest','Off');
	set(handles.preview_axes,'Buttondownfcn',btnfcn);

	% =============================
	% Plot rectangle
	% =============================
	if isfield(handles,'roi')
		rectangle('Position',handles.roi.rect,'edgecolor','r','linewidth',2,'linestyle','--');
	end
end
