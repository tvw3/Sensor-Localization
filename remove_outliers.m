function rssi_data = remove_outliers(rssi_data)
%rssi_data is the cell returned from load_rssi
    for i=1:8 %iterate through all sending nodes
        for j=1:8 %iterate through all recieveing nodes
            d=sort(rssi_data{i,j});
            if isempty(d)
                %nothing to remove if there are no RSSI values
            end 
            if ~isempty(d)
                q2 = median(d);
                %gets median of everything less than the median
                q1 = median(d(find(d<q2))); 
                %gets median of everything greater than the median
                q3 = median(d(find(d>q2))); 
                IQR = q3-q1;
                min = q1-1.5*IQR;
                max = q3+1.5*IQR;
                %gets everything greater than the min
                d = d(find(d>min));
                %gets everything lessthan the max
                d = d(find(d<max));
                %replace old data with new data
                rssi_data{i,j} = d;
            end
        end
    end
end