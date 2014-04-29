function handles=plotoutput(handles)
	mincounts=get(handles.Mincounts,'Value');
	maxcounts=get(handles.Maxcounts,'Value');
	
	cmap=custom_cmap();
	colormap(cmap.wbgyr);

	axes(handles.output_axes);
	imagesc(handles.waterarray,[mincounts,maxcounts]);

	colorbar;
end
