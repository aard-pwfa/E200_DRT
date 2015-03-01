function out = analysis_info()
	out(1).str = 'Butterfly Emittance';
	out(1).func = @emittance_measure_ss;
	out(2).str = 'Waterfall Plot';
	out(2).func = @spectrum_ana;
	out(3).str = 'Waterfall Plot 2';
	out(3).func = @waterfall;
	out(4).str = 'Waterfall_Adli';
	out(4).func = @Waterfall_Adli;
	out(5).str = '2D Flow Plot';
	out(5).func = @flowplot2D;
	out(6).str = 'E224 Interaction';
	out(6).func = @E224Interaction;
end
