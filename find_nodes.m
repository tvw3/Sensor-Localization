function probabilities = find_nodes(rssi_data, node_data)
    %This is the entry point into our program
    %Accepts the rssi data and node locations and displays the
    %probabilities of nodes begin located in different rooms
    
    %load our data
    rssi = load_rssi(rssi_data);
    rssi = remove_outliers(rssi);
    rooms = load_room_data('rooms.csv');
    nodes = load_known_nodes(node_data,rooms);
    %build the model
    model = set_model(get_known_links(nodes, rssi));
    
    %Get operational mode - test should check for nodes being searched for
    %and remove them from our nodes matrix. Operaional should throw a
    %warning if a node being located is already a known node
    mode = 'a';
    while ~strcmp(mode,'t') && ~strcmp(mode,'o');
        mode = lower(input('Enter operational mode: T for test, O for operational: ','s'));
    end
    %Separated this out for better formating and easier reading
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
    
    %Time to calculate probabilities
    
    %construct that holds all located node intersections
    wins = cell(1,length(nodes_to_locate));
    
    %loop through all nodes to locate -- initially 2
    for i = (1:length(nodes_to_locate));
        current = {'node#',nodes_to_locate(i)};
        %loop through all rooms to get all candidate rooms
        for j = (1:length(rooms))
            %get the number of wins fr a single node
            n_wins = get_wins(nodes_to_locate(i),rooms(j,:),nodes,rssi(nodes_to_locate(i) + 1,:),model);
            if n_wins(1) > 0;
                current = [current; {rooms{j} n_wins(1)}];
            end
        end
        wins{i} = current
    end
    %get the probability table for 1 or 2 nodes t find
    probabilities = format_results(wins);
end

