function handles=init_corrs(handles,data)
	corr_str_raw=fieldnames(data.raw.scalars);
	corr_str_proc = fieldnames(data.processed.scalars);
	% First is special: just use index.
	corr_str=['As taken';corr_str_raw;corr_str_proc];
	corr_settings = {{'As taken'},{'NA'}};
	for i=1:length(corr_str_raw)
		corr_settings = [corr_settings;{corr_str_raw{i},'raw'}];
	end
	for i=1:length(corr_str_proc)
		corr_settings = [corr_settings;{corr_str_proc{i},'processed'}];
	end
	handles.corr_settings = corr_settings
	set(handles.Xcorrpopup,'String',corr_str);
	set(handles.Ycorrpopup,'String',corr_str);
end
