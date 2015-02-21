data_rssi = load_rssi('rssi_data_trial_1.csv');
data_room = load_room_data('rooms.csv');
data_nodes = load_known_nodes('node_locations.csv',data_room);
centered = center_XY(data_room);
prob = set_prob(data_room, data_nodes);
prior_prob = trim(prob, data_nodes, centered, data_rssi);