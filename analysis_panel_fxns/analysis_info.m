function out = analysis_info()
	out(1).str = 'Butterfly Emittance';
	out(1).func = @emittance_measure_ss;
	out(2).str = 'Waterfall Plot';
	out(2).func = @spectrum_ana;
end
