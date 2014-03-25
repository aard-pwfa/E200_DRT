function str=flattenstringrows(result)
	comment = cellstr(result);
	str = '';
	for i=1:numel(comment)-1
		str = [str comment{i} '\n'];
	end
	str = [str comment{end}];
end
