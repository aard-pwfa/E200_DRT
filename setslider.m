function setslider(value,sliderhandle,texthandle)
	% Get rounded value
	value = round(value);

	% Set slider to rounded value
	set(sliderhandle,'Value',value);

	% Set text to rounded value
	set(texthandle,'String',num2str(value));
end
