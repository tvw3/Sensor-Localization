function [ Tx , Rx , RSSI, dist, mat_count] = get_coors(filename)
    % Set up x-y cooridinates from rssi and log distance equation

    raw_data = xlsread(filename);
    %number of nodes, add 1 to account for zero index
    n = max(raw_data(:,1)) + 1;
    Tx = cell(n,1);
    Rx = cell(n,1);
    RSSI = cell(n,1);
    dist = cell(n,1);
    [rows cols] = size(raw_data);

    for i = (1:rows);
        %add one to account for zero index
        Tx{i} = raw_data(i,1);
        Rx{i} = raw_data(i,2);
        RSSI{i} =raw_data(i,3);
        [dist{i}] = getDistance(raw_data(i,1),raw_data(i,2));        
    end

    Tx = cell2mat(Tx);
    Rx = cell2mat(Rx);
    RSSI = cell2mat(RSSI);
    dist = cell2mat(dist);
    mat = unique(dist);
    mat = cat(2, mat ,mat);
    for j =(1:24);
        mat(j,2)=0;
    end
    j=length(dist);
    for i = 1:j;
        for k = 1:24;
            if mat(k,1)==dist(i);            
                mat(k,2) = mat(k,2) +1;
            end
        end
    end
    
    mat_count = mat;
end

