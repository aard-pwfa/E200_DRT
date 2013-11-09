function out = analysis_info()
	out(1).str = 'Butterfly Emittance';
	out(1).func = @emittance_measure_ss;
end
