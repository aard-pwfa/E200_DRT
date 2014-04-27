function spectrum_ana(handles)
	% =====================================
	% Use loaded data
	% =====================================
	data = handles.data;

	select_roi = 0;
	
	header = '';
	dataset = num2str(data.raw.metadata.param.dat{1}.n_saves);
	
	SYAG = data.raw.images.SYAG;
	% SYAG_bg = load([header SYAG.background_dat{1}]);
	
	CMOS_NEAR = data.raw.images.CMOS_NEAR;
	% CMOS_NEAR_bg = load([header CMOS_NEAR.background_dat{1}]);
	
	CMOS_FAR = data.raw.images.CMOS_FAR;
	% CMOS_FAR_bg = load([header CMOS_FAR.background_dat{1}]);
	Eaxis_CF = E200_cher_get_E_axis('20131116', 'CMOS', 0, 1:2559, 0, 20.35);
	esub = fliplr(Eaxis_CF);
	
	%CF_bg_img = fliplr(CMOS_bg.img);
	
	EPICS_UID = data.raw.scalars.PATT_SYS1_1_PULSEID.UID;
	[meep,EPICS_CMOS_NEAR,CMOS_NEAR_index] = intersect(EPICS_UID,CMOS_NEAR.UID);
	[moop,EPICS_CMOS_FAR,CMOS_FAR_index] = intersect(EPICS_UID,CMOS_FAR.UID);
	[morp,EPICS_SYAG,SYAG_index] = intersect(EPICS_UID,SYAG.UID);
	n_CMOS_NEAR = numel(CMOS_NEAR_index);
	n_CMOS_FAR = numel(CMOS_FAR_index);
	n_syag = numel(SYAG_index);
	
	
	toro_2452_tmit = data.raw.scalars.GADC0_LI20_EX01_AI_CH0_.dat;
	toro_3163_tmit = data.raw.scalars.GADC0_LI20_EX01_AI_CH2_.dat;
	toro_3255_tmit = data.raw.scalars.GADC0_LI20_EX01_AI_CH3_.dat;
	bpms_2445_x    = data.raw.scalars.BPMS_LI20_2445_X.dat;
	bpms_2445_y    = data.raw.scalars.BPMS_LI20_2445_Y.dat;
	bpms_2445_tmit = data.raw.scalars.BPMS_LI20_2445_TMIT.dat;
	bpms_3156_x    = data.raw.scalars.BPMS_LI20_3156_X.dat;
	bpms_3156_y    = data.raw.scalars.BPMS_LI20_3156_Y.dat;
	bpms_3156_tmit = data.raw.scalars.BPMS_LI20_3156_TMIT.dat;
	bpms_3265_x    = data.raw.scalars.BPMS_LI20_3265_X.dat;
	bpms_3265_y    = data.raw.scalars.BPMS_LI20_3265_Y.dat;
	bpms_3265_tmit = data.raw.scalars.BPMS_LI20_3265_TMIT.dat;
	bpms_3315_x    = data.raw.scalars.BPMS_LI20_3315_X.dat;
	bpms_3315_y    = data.raw.scalars.BPMS_LI20_3315_Y.dat;
	bpms_3315_tmit = data.raw.scalars.BPMS_LI20_3315_TMIT.dat;
	pyro           = data.raw.scalars.BLEN_LI20_3014_BRAW.dat;
	laser          = data.raw.scalars.PMTR_LA20_10_PWR.dat;
	laser_on = laser > 5;
	laser_off = laser < 5;
	
	if isfield(data.raw.metadata,'n_steps')
	    is_scan = 1;
	    
	    n_step         = data.raw.metadata.n_steps;
	    step_num       = data.raw.scalars.step_num.dat;
	    step_val       = data.raw.scalars.step_value.dat;
	    
	    step_num_cmos_near = step_num(CMOS_NEAR_index);
	    step_num_cmos_far = step_num(CMOS_FAR_index);
	    step_num_syag = step_num(SYAG_index);
	    
	    step_val_cmos_near = step_val(CMOS_NEAR_index);
	    step_val_cmos_far = step_val(CMOS_FAR_index);
	    step_val_syag = step_val(SYAG_index);
	    
	else
	    is_scan = 0;
	    
	    n_step = 1;
	    step_num       = data.raw.scalars.step_num.dat;
	    step_val       = data.raw.scalars.step_num.dat;
	
	    step_val_cmos_near = step_val(CMOS_NEAR_index);
	    step_val_cmos_far = step_val(CMOS_FAR_index);
	    step_val_syag = step_val(SYAG_index);
	    
	    step_num_cmos_near = step_num(CMOS_NEAR_index);
	    step_num_cmos_far = step_num(CMOS_FAR_index);
	    step_num_syag = step_num(SYAG_index);
	    
	end
	
	% syag_roi.top = 175;
	% syag_roi.bottom = 225;
	% syag_roi.left = 300;
	% syag_roi.right = 1100;
	% syag_roi.rot = 2;
	% SYAG_ANA = basic_image_ana(SYAG,0,syag_roi,header);
	% wit = sum(SYAG_ANA.x_profs(95:310,:));
	% drive = sum(SYAG_ANA.x_profs(365:755,:));
	% SYAG_ANA.sum = sum(SYAG_ANA.x_profs);
	% SYAG_ANA.witness_charge = wit;%./SYAG_ANA.sum;
	% SYAG_ANA.drive_charge = drive;%./SYAG_ANA.sum;
	
	% roi.top = 200;
	% roi.bottom = 730;
	% roi.left = 350;
	% roi.right = 850;
	% roi.rot = 0;
	%CMOS_NEAR_ANA = basic_image_ana(CMOS_NEAR,0,roi,header);
	
	%%
	
	if select_roi || ~exist('my_roi')
	    image = imread(CMOS_FAR.dat{1});
	    image = rot90(image,3);
	    figure(1); imagesc(image); caxis([0 1000]);
	    my_roi = ginput(2);
	end
	cmos_roi.top = round(my_roi(1,2));
	cmos_roi.bottom = round(my_roi(2,2));
	cmos_roi.left = round(my_roi(1,1));
	cmos_roi.right = round(my_roi(2,1));
	
	esub = esub(cmos_roi.top:cmos_roi.bottom);
	cmos_roi.rot = 3;
	CMOS_FAR_ANA = basic_image_ana(CMOS_FAR,1,cmos_roi,header);
	
	%%
	
	if is_scan
	    %qs_x = linspace(step_val_cmos_far(1),step_val_cmos_far(end),n_CMOS_FAR);
	    qs_x = 1:n_CMOS_FAR;
	else
	    qs_x = 1:n_CMOS_FAR;
	end
	cmos_laser_on = laser_on(CMOS_FAR_index);
	cmos_laser_off = laser_off(CMOS_FAR_index);
	cmos_specs = CMOS_FAR_ANA.y_profs(:,CMOS_FAR_index);
	
	figure(2); pcolor(qs_x,esub,cmos_specs); shading flat; box off;
	if is_scan
	    xlabel('Imaging Energy Relative to 20.35 GeV [GeV]','fontsize',16);
	    set(gca, 'XTick', (data.raw.metadata.param.dat{1}.n_shot/2):data.raw.metadata.param.dat{1}.n_shot:(n_CMOS_FAR-data.raw.metadata.param.dat{1}.n_shot/2));
	    set(gca, 'XTickLabel', data.raw.metadata.param.dat{1}.PV_scan_list);
	    for i = 1:(n_step-1)
	        line([i*data.raw.metadata.param.dat{1}.n_shot i*data.raw.metadata.param.dat{1}.n_shot],[esub(1) esub(end)],'color','k','linestyle','--');
	    end
	end
	cmap  = custom_cmap();
	colormap(cmap.wbgyr);
	caxis([450 900]);
	%caxis([335 1200]);
	if is_scan 
	    xlabel('Imaging Energy Relative to 20.35 GeV [GeV]','fontsize',16);
	else
	    xlabel('Shot Number','fontsize',16);
	end
	
	ylabel('Energy [GeV]','fontsize',16);
	title(['Dataset ' dataset '. Plasma in. Laser 1/2 Hz.'],'fontsize',16);
	%title(['Dataset ' dataset '. Plasma in. No witness beam. Laser 1/2 Hz.']);
	%title(['Dataset ' dataset '. Plasma out. Laser 1/2 Hz.']);
	set(gca,'fontsize',16);
	
	% sy_x = 1:n_syag;
	% syag_disp = 100;
	% delta = 100*SYAG.RESOLUTION(1)/(1000*syag_disp)*(1:(SYAG_ANA.roi.right-SYAG_ANA.roi.left+1));
	% delta =  delta - mean(delta);
	% 
	% good_profs = SYAG_ANA.x_profs(:,SYAG_index);
	% drive = SYAG_ANA.drive_charge(SYAG_index);
	% [a,b] = sort(drive);
	% 
	% figure(3); pcolor(delta,sy_x,good_profs(:,b)'); shading flat;
	% ylabel('Shot number');
	% xlabel('\delta [%]');
	
	%% compare syag and cmos
	% [list,sy_ind,cf_ind]=intersect(SYAG.UID,CMOS_FAR.UID);
	% 
	% sy_comp_profs = SYAG_ANA.x_profs(:,sy_ind);
	% cf_comp_profs = CMOS_FAR_ANA.y_profs(:,cf_ind);
	% 
	% sort_var = SYAG_ANA.drive_charge(sy_ind);
	% %sort_var = SYAG_ANA.witness_charge(sy_ind);
	% [a,sorted] = sort(sort_var);
	% 
	% figure(4); pcolor(1:numel(cf_ind),esub,cf_comp_profs(:,sorted)); shading flat;
	% colormap(cmap.wbgyr);
	
	
	%%
	
	figure(3);
	specs = CMOS_FAR_ANA.y_profs(:,CMOS_FAR_index);
	total_spec = mean(CMOS_FAR_ANA.y_profs,2);
	mean_specs = zeros(numel(esub),n_step+1);
	dns = zeros(1,numel(CMOS_FAR_index));
	stds = zeros(1,n_step);
	means = zeros(1,n_step);
	for i = 1:n_step
	    step_specs = specs(:,step_num_cmos_far==i);
	    hi = 20.35 + data.raw.metadata.param.dat{1}.PV_scan_list(i) + 0.5;
	    lo = 20.35 + data.raw.metadata.param.dat{1}.PV_scan_list(i) - 0.5;
	    range = esub > lo & esub < hi;
	    dns(step_num_cmos_far==i) = mean(step_specs(range,:));
	    stds(i) = std(dns(step_num_cmos_far==i));
	    means(i) = mean(dns(step_num_cmos_far==i));
	    mean_specs(:,i) = mean(step_specs,2);
	end
	
	pcolor(1:(n_step+1),esub,mean_specs); shading flat; box off;
	set(gca, 'XTick', (1:n_step)+0.5);
	set(gca, 'XTickLabel', data.raw.metadata.param.dat{1}.PV_scan_list);
	xlabel('Imaging Energy Relative to 20.35 GeV [GeV]','fontsize',16);
	ylabel('Energy [GeV]','fontsize',16);
	title(['Dataset ' dataset '. Average Spectra. Plasma in. Laser 1 Hz.'],'fontsize',16);
	set(gca,'fontsize',16);
	
	colormap(cmap.wbgyr);
	caxis([450 1400]);
	
	figure(4);
	plot(step_val_cmos_far,dns,'s');
	xlabel('Imaging Energy Relative to 20.35 GeV [GeV]','fontsize',16);
	ylabel('dN/dE [Counts/GeV]','fontsize',16);
	
	figure(5);
	errorbar(data.raw.metadata.param.dat{1}.PV_scan_list,means,stds,'s');
	axis([-1 16 0 8000]);
	xlabel('Imaging Energy Relative to 20.35 GeV [GeV]','fontsize',16);
	ylabel('dN/dE [Counts/GeV]','fontsize',16);
end
