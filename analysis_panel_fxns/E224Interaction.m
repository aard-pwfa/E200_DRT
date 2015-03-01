% Brendan sucks at this.
function handles = E224Interaction(handles)
    % The path to the DAQ of interest.
    %pathTemp = '/nas/nas-li20-pm00/E200/2015/20150228/E200_14629/E200_14629.mat';
    
    % Load the DAQ information
    %holder = E200_load_data(pathTemp);
    
    holder = handles.data;
    
    % YOu load the images based on UID, so grab those.
    UIDlist1 = holder.raw.images.E224_Trans.UID;
    UIDlist2 = holder.raw.images.CMOS_ELAN.UID;
    
    UIDMaster = intersect(UIDlist1,UIDlist2);
    
    % Now load the images.
    E224_Trans = holder.raw.images.E224_Trans;
    % imagesE224 = E200_load_images(holder.raw.images.E224_Trans,UIDMaster);
    % imagesCMOS = E200_load_images(holder.raw.images.CMOS_ELAN,UIDMaster);
    
    %% Analyze the E224 image looking for the stripe
    % _______________________________________________________________________
    N_E224 =  length(UIDMaster);
    
    E224CameraSums = zeros(0,length(N_E224));
    
    holder.processed.scalars.E224InteractionStrength.UID = UIDMaster;
    holder.processed.scalars.E224InteractionStrength.dat = zeros(1,N_E224);
    holder.processed.scalars.E224InteractionStrength.desc = 'Interaction strength based on summing';
    E224InteractionStrength = holder.processed.scalars.E224InteractionStrength;

    disp('Processing...');
    
    for i = UIDMaster
        img = E200_load_images(E224_Trans,i);
        ind = find(E224InteractionStrength.UID == i);
        holder.processed.scalars.E224InteractionStrength.dat(ind) = sum(sum(img{1}));
    end

    handles.data = holder;

    disp('Processed stuff!')
    
    % _______________________________________________________________________
    
    
    % Analyze the ELANX figure looking for "interaction"
    % _______________________________________________________________________
    
    % _______________________________________________________________________
end
