rssi_data = load_rssi('rssi_model_set.csv');
rssi_data = remove_outliers(rssi_data);

room_data = load_room_data('rooms.csv');
room_data= center_XY(room_data);

nodes_data = load_known_nodes('model_locations.csv',room_data);

known_links = get_known_links(nodes_data, rssi_data);

model = set_model(known_links);


% one node unknown
rssi_data = load_rssi('rssi_data_trial_1.csv');
rssi_data = remove_outliers(rssi_data);
known_nodes_data = load_known_nodes('node_locations-0.csv',room_data);
probability_table = 2;
test_known_links = get_known_links(known_nodes_data,rssi_data);
unknown_links = get_unknown_links(test_known_links,rssi_data, model);

in_range(test_known_links ,room_data, known_nodes_data, probability_table, model, unknown_links)

%two node unknown
rssi_data = load_rssi('rssi_data_trial_1.csv');
rssi_data = remove_outliers(rssi_data);
known_nodes_data = load_known_nodes('node_locations-0-3.csv',room_data);
probability_table = 2;
test_known_links = get_known_links(known_nodes_data,rssi_data);
unknown_links = get_unknown_links(test_known_links,rssi_data, model);

in_range(test_known_links ,room_data, known_nodes_data, probability_table, model, unknown_links)

rssi_data = load_rssi('rssi_data_trial_1.csv');
rssi_data = remove_outliers(rssi_data);
known_nodes_data = load_known_nodes('node_locations-1-6.csv',room_data);
probability_table = 2;
test_known_links = get_known_links(known_nodes_data,rssi_data);
unknown_links = get_unknown_links(test_known_links,rssi_data, model);

in_range(test_known_links ,room_data, known_nodes_data, probability_table, model, unknown_links)

% three node unknown
rssi_data = load_rssi('rssi_data_trial_1.csv');
rssi_data = remove_outliers(rssi_data);
known_nodes_data = load_known_nodes('node_locations-0-5-6.csv',room_data);
probability_table = 2;
test_known_links = get_known_links(known_nodes_data,rssi_data);
unknown_links = get_unknown_links(test_known_links,rssi_data, model);

in_range(test_known_links ,room_data, known_nodes_data, probability_table, model, unknown_links)
