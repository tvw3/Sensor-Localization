function d = get_distance(PL)
%Our model for distance
%PL is the measured rssi
%d is the estimated distance
    d = (18) * (10 ^ ((PL - (-53))/-(10 * 3)));
end