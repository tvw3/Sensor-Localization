function d = get_distance(PL, knownRoom,possibleRoom)

%Our model for distance
%PL is the measured rssi
%PL0 is the reference rssi value
%alpha is the exponential constant
%d0 is the reference distance
%d is the estimated distance

PL0 = -43;
alpha = 3;
d0= 18;
    d = d0 * (10 ^ ((PL - PL0)/-(10 * alpha))) - 9 * get_walls(knownRoom, possibleRoom)^(2.7/1.78);
end