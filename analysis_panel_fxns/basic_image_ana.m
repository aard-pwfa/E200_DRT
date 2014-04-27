function IM_ANA = basic_image_ana(im_struct,use_bg,roi,header)

ntotal = im_struct.N_IMGS;

if use_bg
    bg = load([header im_struct.background_dat{1}]);
    %bg = fliplr(bg.img);
end
    

nv = roi.bottom - roi.top + 1;
nh = roi.right - roi.left + 1;

x_axis = im_struct.RESOLUTION(1)*((1:nh) - nh/2);
y_axis = im_struct.RESOLUTION(1)*((1:nv) - nv/2);

IM_ANA.x_profs = zeros(nh,ntotal);
IM_ANA.y_profs = zeros(nv,ntotal);
IM_ANA.x_max = zeros(1,ntotal);
IM_ANA.y_max = zeros(1,ntotal);
IM_ANA.x_cent = zeros(1,ntotal);
IM_ANA.y_cent = zeros(1,ntotal);
IM_ANA.x_rms = zeros(1,ntotal);
IM_ANA.y_rms = zeros(1,ntotal);

disp(['Analyzing ' num2str(ntotal) ' images.']);

for i = 1:ntotal
    
    image = imread([header im_struct.dat{i}]);
    
    if roi.rot
        image = rot90(image,roi.rot);
    end
    
    if use_bg
        image = image - bg.img;
    end
    
    image = image(roi.top:roi.bottom,roi.left:roi.right);
    x_prof = mean(image);
    y_prof = mean(image,2);
    
    [mx,ix] = max(x_prof);
    [my,iy] = max(y_prof);
    
    xc = wm(x_axis,x_prof,1);
    xrms = wm(x_axis,x_prof,2);
    
    yc = wm(y_axis,y_prof,1);
    yrms = wm(y_axis,y_prof,2);
    
    IM_ANA.x_max(i) = x_axis(ix);
    IM_ANA.y_max(i) = y_axis(iy);
    
    IM_ANA.x_cent(i) = xc;
    IM_ANA.x_rms(i) = xrms;
    
    IM_ANA.y_cent(i) = yc;
    IM_ANA.y_rms(i) = yrms;
    
    IM_ANA.x_profs(:,i) = x_prof;
    IM_ANA.y_profs(:,i) = y_prof;
    
end

IM_ANA.x_axis = x_axis;
IM_ANA.y_axis = y_axis;
IM_ANA.roi = roi;
