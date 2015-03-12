function main(rssi_data, node_location)
    %This is the entry point into our program
    %rssi_data - the csv containing all rssi data
    %node_locations - the csv containing all known node locations
    
    %Add the required subdirectories to the path if they are not already
    %Requires that this main function be in the primary matlab directory
    %THIS MUST ALWAYS BE THE FIRST COMMAND RUN
    addpath(genpath('Sensor-Localization'))

    %load the rssi data and remove outliers from the data set
    rssi = remove_outliers(load_rssi(rssi_data));
    %load the room and node location data
    rooms = load_room_data('rooms.csv');
    nodes = load_known_nodes(node_data,rooms);

    %build the model - may be changed later
    model = set_model(get_known_links(nodes, rssi));


    %Get operational mode - test should check for nodes being searched for
    %and remove them from our nodes matrix. Operaional should throw a
    %warning if a node being located is already a known node
    mode = 'a';
    while ~strcmp(mode,'t') && ~strcmp(mode,'o');
        mode = lower(input('Enter operational mode: T for test, O for operational: ','s'));
    end
    
    %Separated this out for better formatting and easier reading
    %sprint allows the use of newline for formatting
    node_input_string =sprintf(['Enter the node that you wish to locate.\n' ...
        'If you would like to locate multiple nodes, please place them in\n' ...
        'in brackets, separated by white space (e.g. [1 2 3]: ']);
    
    %Get the node, or nodes, that need to be located
    nodes_to_locate = eval(input(node_input_string,'s'));
    
    %based on operational mode, we want to initially do different things
    %with the data
    if mode == 't';
        %remove the nodes to find from the list of known nodes
        nodes = clean_nodes(nodes,nodes_to_locate);
    else
        %check if the nodes to find already exist
        if(check_nodes(nodes, nodes_to_locate));
            %They do, warn the user
           fprintf('Warning: Nodes to be located may already exist as known nodes\n'); 
        end
    end
    
    %Get the probability of all possible room permutations
    probabilities = get_room_candidates(rssi, rooms, nodes, nodes_to_locate);
    
    %Display the results
    display_results(probabilities);
end

