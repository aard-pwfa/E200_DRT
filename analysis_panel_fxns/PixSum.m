% Brendan sucks at this.
function handles = E224Interaction(handles,hObject)
	% The path to the DAQ of interest.
	%pathTemp = '/nas/nas-li20-pm00/E200/2015/20150228/E200_14629/E200_14629.mat';
	
	% Load the DAQ information
	%data = E200_load_data(pathTemp);
	
	data = handles.data;
	
	camname = handles.camname;
	% YOu load the images based on UID, so grab those.
	% UIDlist1 = data.raw.images.E224_Trans.UID;
	% UIDlist2 = data.raw.images.CMOS_ELAN.UID;
	
	% UIDMaster = intersect(UIDlist1,UIDlist2);
	UIDMaster = data.raw.images.(camname).UID;
	UIDMaster = UIDMaster(UIDMaster > 1);

	% Now load the images.
	cam_str = data.raw.images.(camname);
	% imagesE224 = E200_load_images(data.raw.images.E224_Trans,UIDMaster);
	% imagesCMOS = E200_load_images(data.raw.images.CMOS_ELAN,UIDMaster);
	
	%% Analyze the E224 image looking for the stripe
	% _______________________________________________________________________
	N_E224 =  length(UIDMaster);
	
	E224CameraSums = zeros(0,length(N_E224));
	pxsum_name=[camname '_pxsum'];
	data.processed.scalars.(pxsum_name).UID = [];
	data.processed.scalars.(pxsum_name).dat = [];
	data.processed.scalars.(pxsum_name).desc = 'Interaction strength based on summing';
	E224InteractionStrength = data.processed.scalars.(pxsum_name);

	disp('Processing...');
	
	for i = UIDMaster
		disp(['Processing uid: ' num2str(i)])
		img = E200_load_images(cam_str,i);
		E224InteractionStrength.UID = [E224InteractionStrength.UID, i];
		E224InteractionStrength.dat = [E224InteractionStrength.dat, sum(sum(img{1}))];
		% try
		%	disp(['Processing uid: ' num2str(i)])
		%	img = E200_load_images(E224_Trans,i);
		%	E224InteractionStrength.UID = [E224InteractionStrength.UID; i];
		%	E224InteractionStrength.dat = [E224InteractoinStrength.dat; sum(sum(img{1}))];
		% catch
		%	disp(['Error with uid: ' num2str(i)])
		% end
	end

	data.processed.scalars.(pxsum_name) = E224InteractionStrength;

	handles.data = data;

	disp('Processed stuff!')
	
	% _______________________________________________________________________
	
	
	% Analyze the ELANX figure looking for "interaction"
	% _______________________________________________________________________
	
	% _______________________________________________________________________
end
