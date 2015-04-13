function plotout(min_counts,max_counts,water_array)
    
    cmap=custom_cmap();
    colormap(cmap.wbgyr);

    imagesc(water_array,[min_counts,max_counts]);

    % colorbar;
end
