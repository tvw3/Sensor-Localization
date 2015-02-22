function d = get_distance(PL,PL0,alpha,d0)
%Our model for distance
%PL is the measured rssi
%PL0 is the reference rssi value
%alpha is the exponential constant
%d0 is the reference distance
%d is the estimated distance
    d = d0 * (10 ^ ((PL - PL0)/-(10 * alpha)));
end