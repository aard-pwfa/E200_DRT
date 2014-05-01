function plotout(handles)
	mincounts=get(handles.Mincounts,'Value');
	maxcounts=get(handles.Maxcounts,'Value');
	
	cmap=custom_cmap();
	colormap(cmap.wbgyr);

	imagesc(handles.waterarray,[mincounts,maxcounts]);

	colorbar;
end
