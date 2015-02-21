function [ meanD ] = distance_mean( rssi )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

%     maxD = min(rssi);
     meanD = mean(rssi/2);
%     minD = min(rssi);

    alpha = 3;
    d0 = 10;
    PL0 = -42;
    
%     minD = get_distance(minD,PL0,alpha,d0);
     meanD = get_distance(meanD,PL0,alpha,d0);
%     maxD = get_distance(maxD,PL0,alpha,d0);

end

