function probabilities = Prior_Distribution(rssi, rooms, known, node_to_locate)
    test_known_links = get_known_links(known,rssi);
    unknown_links = get_unknown_links(test_known_links,rssi);
    probabilities = in_range(test_known_links ,rooms, known, unknown_links);


