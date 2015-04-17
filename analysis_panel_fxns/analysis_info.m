function out = analysis_info()
	out(1).str = 'Waterfall Plot';
	out(1).func = @waterfall;
	out(2).str = '2D Flow Plot';
	out(2).func = @flowplot2D;
	out(3).str = 'PixSum';
	out(3).func = @PixSum;
	% out(4).str = 'PxSum';
	% out(4).func = @PxSum;
end
