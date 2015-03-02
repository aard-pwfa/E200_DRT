function handles=plotoutput(ax,handles)
	axes(ax);
	mincounts=get(handles.Mincounts,'Value');
	maxcounts=get(handles.Maxcounts,'Value');
	waterarray = handles.waterarray;

	plotout(mincounts,maxcounts,waterarray);
	if get(handles.rotation,'Value')
		addlabels('Shot (sorted)','px','');
	else
		addlabels('px','Shot (sorted)','');
	end
end
