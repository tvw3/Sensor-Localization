function data = load_rssi(filename)
    %read in raw number data
    raw_data = xlsread(filename);
    %number of nodes, add 1 to account for zero index
    n = max(raw_data(:,1)) + 1;
    %number of rows and cols of data
    [rows cols] = size(raw_data);
    %format our nxn matrix
    data = cell(n,n);
    for i = (1:rows);
        %add one to account for zero index caused by starting at node 0
        sending = raw_data(i,1) + 1;
        receiving = raw_data(i,2) + 1;
        rssi = raw_data(i,3);
        data{sending,receiving} = [data{sending,receiving} rssi];
    end
end