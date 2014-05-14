function emittance_measure_ss(handles)
	addpath(fullfile(pwd,'analysis_panel_fxns','FACET_Emittance'));
	curpath=pwd;
	scriptpath=which('matlab_script.m');
	[Path,File,Ext]=fileparts(scriptpath);
	cd(Path);
	matlab_script(handles.data,handles.camname,handles.imgnum)
	cd(curpath);
end
