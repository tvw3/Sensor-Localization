function main(rssi_data, node_locations)
    %This is the entry point into our program
    %rssi_data - the csv containing all rssi data
    %node_locations - the csv containing all known node locations
    
    %Add the required subdirectories to the path if they are not already
    %Requires that this main function be in the primary matlab directory
    %THIS MUST ALWAYS BE THE FIRST COMMAND RUN
    addpath(genpath('Sensor-Localization'))

    %load the rssi data and remove outliers from the data set
    rssi = (load_rssi(rssi_data));
    %load the room and node location data
    rooms = load_room_data('rooms.csv');
    rooms = center_XY(rooms);
    nodes = load_known_nodes(node_locations,rooms);
    
    %load the wall data
%     walls = load_walls('Walls.csv');
% 
    %Get operational mode - test should check for nodes being searched for
    %and remove them from our nodes matrix. Operaional should throw a
    %warning if a node being located is already a known node
    mode = 'a';
    while ~strcmp(mode,'t') && ~strcmp(mode,'o');
        mode = lower(input('Enter operational mode type: T for test, O for operational: ','s'));
    end
    
    if mode=='t'
        x = 'a';
        while ~endswith(x,'.csv')
            x = input('What is the name of the file with all node information? (e.g. full_node_list.csv): ', 's');
        end
        all_nodes = load_known_nodes(x,rooms);
    else
        all_nodes = 'NA';
    end
    
    
    
    %based on operational mode, we want to initially do different things
    %with the data
    if mode == 't';
        %remove the nodes to find from the list of known nodes
        
        nodes = clean_nodes(nodes,nodes_to_locate);
    else
        %check if the nodes to find already exist
%         if(check_nodes(nodes, nodes_to_locate));
%             %They do, warn the user
%            fprintf('Warning: Nodes to be located may already exist as known nodes\n'); 
%         end
    end
    
    %Get the probability of all possible room permutations
    known_links = get_known_links(nodes,rssi);
    unknown_links = get_unknown_links(known_links,rssi);
    probabilities = in_range(known_links ,rooms, nodes, unknown_links);
    [prob, candi] = get_infer(probabilities,rooms,known_links,unknown_links);
    results = compress(candi,prob);

%     %Display the results
      print(results, all_nodes, length(results(1,:))/2, mode);
end

