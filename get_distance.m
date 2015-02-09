function power = get_distance(PL,PL0,alpha,d0)
    power = d0 * (10 ^ ((PL - PL0)/-(10 * alpha)));
end
