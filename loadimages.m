function handles=loadimages(hObject,handles)
	% global gl
	
	% Disable things while loading
	cla(handles.fig1);
	% set(handles.Stepnumberslider,'Enable','off');
	set(handles.Stepnumbertext,'Enable','off');
	set(handles.Stepnumberslider,'Enable','off');
	set(handles.imageslider,'Enable','off');
	set(handles.Maxcounts,'Enable','off');
	set(handles.Mincounts,'Enable','off');
	
	% Make things cleaner
	data=handles.data;
	
	imgstruct=get_imgstruct(handles);
	handles.imgstruct=imgstruct;
	
	allsteps=get(handles.allsteps,'Value');
	allshots=get(handles.allshots,'Value');
	
	% Use all steps
	if allsteps
		wanted_UID_step=data.raw.scalars.step_num.UID;
	else
		stepval=get(handles.Stepnumberslider,'Value');
		% Seem to need this if running a single step
		% instead of a scan. May be related to disabling
		% Stepnumberslider in GUI
		if stepval == 0
			stepval = 1;
		end
		bool=(data.raw.scalars.step_num.dat==stepval);
		wanted_UID_step=data.raw.scalars.step_num.UID(bool);
	end
	
	display(['Loading images, expect ' num2str(handles.data.raw.metadata.param.dat{1}.n_shot*15/100) ' second wait...']);
	% [handles.images,handles.images_bg]=E200_load_images(imgstruct,wanted_UID_step);
	[images,images_bg]=E200_load_images(imgstruct,wanted_UID_step);
	for i = 1:size(images,1)
		disp(i);
		images{i} = images{i}-uint16(images_bg{i});
	end
	handles.images = images;
	num_img=size(handles.images,2);
	clear images_bg;
	clear images;
	
	handles.maxrawpixel=maxpixel(handles.images);

	set(handles.Maxcounts,'Enable','on');
	set(handles.Maxcounts,'Max',handles.maxrawpixel);
	set(handles.Maxcounts,'Value',handles.maxrawpixel);
	set(handles.Maxcounts,'SliderStep',[0.01,0.1])

	set(handles.Mincounts,'Enable','on');
	set(handles.Mincounts,'Max',handles.maxrawpixel-1);
	set(handles.Mincounts,'Value',0);
	set(handles.Mincounts,'SliderStep',[0.01,0.1])
	
	set(handles.Stepnumberslider,'Enable','on');
	set(handles.Stepnumbertext,'Enable','on');
	
	set(handles.imageslider,'Enable','On');
	set(handles.imageslider,'Max',num_img);
	% set(handles.imageslider,'Value',1);
	set(handles.imageslider,'SliderStep',[1/(num_img-1),10/(num_img-1)])
	
	guidata(hObject,handles);
	
end

function out=maxpixel(imagecell)
	out=0;
	for i=imagecell
		out=max(out,max(max(i{1})));
	end
end
