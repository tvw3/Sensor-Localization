function power = get_distance(rssi,A,y)
    power = 18 * (10 ^ ((rssi + A)/-(10 * y)));
end
