function printfig2elog(fig,data,comment,camname)
	prompt    = {'Elog Title','Comment to Print'};
	dlg_title = 'Add Plot Details and Preview';
	num_lines = [1,30;10,50];
	
	comment = flattenstringrows(comment);
	dataset        = data.raw.metadata.param.save_name;
	comment2print  = sprintf(['Dataset: ' dataset '\n' comment]);
	def            = {['DRT Data from ' camname],comment2print};
	
	result=inputdlg(prompt,dlg_title,num_lines,def);
	comment2print = flattenstringrows(result{2})
	
	printans=questdlg(sprintf(['Comment: \n\n' comment2print '\n\nPrint to Elog?']),'Final Confirmation','Yes','No','No');
	if strcmp(printans,'Yes')
		authstr=data.raw.metadata.param.experiment;
		util_printLog(fig,'title',result{1},'text',sprintf(comment2print),'author',authstr);
	end
end
