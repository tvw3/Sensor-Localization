function power = get_distance(rssi,A,y)
    power = 10 ^ ((rssi + A)/-(10 * y));
end