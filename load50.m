function [handles,varargout]=load50(imgnum,uids,handles)
	set(handles.imageslider,'Enable','Off');
	imgstr=handles.data.raw.images.(handles.camname);
	maximg = length(uids);
	num_groups = ceil(maximg/50);
	if isfield(handles,'curimg_range')
		if imgnum >= min(handles.curimg_range) && imgnum <= max(handles.curimg_range)
			loadnew_bool=false;
		else
			loadnew_bool=true;
		end
	else
		loadnew_bool=true;
	end

	if loadnew_bool
		% Which set of 50 the image is in
		group=ceil(double(imgnum)/50)
		display(['Loading group ' num2str(group) ' of ' num2str(num_groups) ' groups of images...']);
		startind=(group-1)*50 + 1;
		endind = group*50;
		endind = min(endind,maximg);
		[images,images_bg]=E200_load_images(imgstr,uids(startind:endind),'data',handles.data);

		for i = 1:size(images,2)
			% disp(i);
			images{i} = images{i}-uint16(images_bg{i});
		end
		clear images_bg;
		handles.images = images;
		clear images;
		handles.curimg_range=[startind,endind];
	end

	if nargout==2
		adj_img_number = mod(imgnum-1,50)+1;
		display(['Loading adjusted image number ' num2str(adj_img_number)]);
		varargout{1}=handles.images{adj_img_number};
	end
	set(handles.imageslider,'Enable','On');
end
