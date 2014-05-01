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
	
	[imgstruct,handles.camname]=get_imgstruct(handles);
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
		handles.image_UIDs = wanted_UID_step;
	end

	num_img = numel(wanted_UID_step);
	% Load in sets of up to 50 and process.
	num_groups = ceil(num_img/50);
	handles.maxrawpixel=0;
	for i=[num_groups:-1:1]
		first_group_img = (i-1)*50 + 1;
		handles = load50(first_group_img,wanted_UID_step,handles);
		group_maxpixel = maxpixel(handles.images);
		handles.maxrawpixel = max(handles.maxrawpixel,group_maxpixel);
	end

%	numimg=numel(wanted_UID_step)
%	if numimg > 50
%		cprintf('Red',['Number of images is ' num2str(numimg) '! Only accessing first 50.\n']);
%		wanted_UID_step = wanted_UID_step(1:50);
%		numimg=50;
%	end
%	
%	display(['Loading images, expect ' num2str(handles.data.raw.metadata.param.dat{1}.n_shot*15/100) ' second wait...']);
%	% [handles.images,handles.images_bg]=E200_load_images(imgstruct,wanted_UID_step);
%	[images,images_bg]=E200_load_images(imgstruct,wanted_UID_step);
%	for i = 1:size(images,1)
%		disp(i);
%		images{i} = images{i}-uint16(images_bg{i});
%	end
%	clear images_bg;
%	handles.images = images;
%	clear images;
%	num_img=size(handles.images,2);

	[ylim,xlim]=size(handles.images{1});
	set(gca,'XLim',0.5+[0,xlim]);
	set(gca,'YLim',0.5+[0,ylim]);
	
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
	if get(handles.imageslider,'Value')<1
		set(handles.imageslider,'Value',1);
	end
	set(handles.imageslider,'SliderStep',[1/(num_img-1),10/(num_img-1)])
	
	guidata(hObject,handles);
	
end

function out=maxpixel(imagecell)
	out=0;
	for i=imagecell
		out=max(out,max(max(i{1})));
	end
end
