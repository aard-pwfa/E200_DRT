function handles=createwaterfall(handles)
    global ghandles;

    imgstr=handles.handles_main.data.raw.images.(handles.handles_main.camname);
    handles.uids = imgstr.UID;
    handles.numimgs=length(handles.uids);
    
    display(['Processing ' num2str(handles.numimgs) ' into waterfall...']);
    % ====================================
    % Set rotation variables
    % ====================================
    if get(handles.rotation,'Value')
        vertical_bool = true;
        sum_dimension = 2;
        arraysize = handles.roi.maxy-handles.roi.miny+1;
    else
        vertical_bool = false;
        sum_dimension = 1;
        arraysize = handles.roi.maxx-handles.roi.minx+1;
    end

    % ====================================
    % Create array
    % ====================================
    waterarray=zeros(handles.numimgs,arraysize);
    for i=1:handles.numimgs
        if mod(i,10)==0
            display(['Image number ' num2str(i)]);
        end
        images=E200_load_images(imgstr,handles.uids(i));
        images=images{1};
        subimg=images(handles.roi.miny:handles.roi.maxy,handles.roi.minx:handles.roi.maxx);
        subimg=sum(subimg,sum_dimension);
        waterarray(i,:)=subimg;
    end

    handles.waterarray_unsort=waterarray;

    % display('Finished!');
    handles = finishwaterfall(handles);

    ghandles = handles;
end
