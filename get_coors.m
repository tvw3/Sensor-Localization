function [ X , Y , Z, dist] = get_coors(filename)
    % Set up x-y cooridinates from rssi and log distance equation

    raw_data = xlsread(filename);
    %number of nodes, add 1 to account for zero index
    n = max(raw_data(:,1)) + 1;
    X = cell(n,1);
    Y = cell(n,1);
    Z = cell(n,1);
    dist = cell(n,1);
    %PL0 max rssi of entire dataset
    PL0 = -43;
    %d0 set 1m one tranmission power infered by PL0
    d0 = 1;
    alpha = 3;

    %number of rows and cols of data
    [rows cols] = size(raw_data);
    %format our nxn matrix
%    data = cell(n,n);
    for i = (1:rows);
        %add one to account for zero index
        X{i} = raw_data(i,1);
        Y{i} = raw_data(i,2);
        Z{i} =raw_data(i,3);
        dist{i} = get_distance(Z{i},PL0,alpha,d0);
        %data{sending,receiving} = [data{sending,receiving} rssi];
    end
    X = cell2mat(X);
    Y = cell2mat(Y);
    Z = cell2mat(Z);
    dist = cell2mat(dist);
end

