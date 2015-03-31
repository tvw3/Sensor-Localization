function [ update_prob ] = in_range( known_links ,room_data, known_nodes_data, unknown_links);
%returns a two column array [RmStringID || probability] for unknown nodes
%the unknown node potential list is delimited by its integer node id in
% column 1 and and empty cell in column two
    
    % creates a matrix of all end links from known start nodes
    end_nodes = [];
    end_nodes = [end_nodes unknown_links{:,2} unknown_links{:,1}];
    
    known_node_id = unique(known_links(:,1));
    % creates a matrix of all known start nodes
    start_nodes = [];
    start_nodes = [start_nodes known_links{:,2}];

    % create matrix of unknown nodes and all_nodes
    unknown_nodes = setdiff(end_nodes,start_nodes);
    all_nodes = union(end_nodes,start_nodes);
    
    %gets totalnumber of possible links N-1
    link_length = (length(all_nodes)-1);

    if isempty(unknown_nodes)
        update_prob = {};
        return
    end

    [known_row known_col] = size(known_links);
%     [unknown_row unknown_col] = size(unknown_links);

    % creates a two column array for each unknown nodes with the column one
    % being the room id and the second the estimated link distance based on 
    % maximum rssi data point in the data set for that link This is 
    % repeated for each node and the Table is concatenate horizontal with   
    % each new unknown node

    for j = (1:length(unknown_nodes));
        stuff = cell(link_length,2);
        index =1;
        for i =(1:known_row);
            if unknown_nodes(1,j)==known_links{i,3};
                stuff{index,1} = known_links{i,1};
                stuff{index,2} = get_distance(max(known_links{i,4}), ' ', ' ');
                index = index +1;
            end
        end
        if j==1;
            Table = stuff;           
        else
            Table = cat(2,Table,stuff);
        end
    end
    [m, n] = size(Table);
    [ rows, columns] = size(room_data);
    
    offset = 2;
    candidates = {};
    index =1;
    % This is a depth 4 nested loop that generates a list of rooms 
    % that are within the range of known nodes based on the area intersection
    % for each unknown node with the outer most loop interating over the
    % Table previously generated
    while offset <= n;
        trigger = 1;
        % This loop iterated down the column containning distances
        for a = (1:m);
            potentials = {};
            % conditional to skip over empty cells
            if ~(isempty(Table{a,offset}));       
                % finds index for known node to be used for start point XY
                % and looks up link distance previously generated
                start_index = find(ismember(room_data(:,1),Table(1,offset-1)));
                radius = Table{a,offset};
                % interates through all possible rooms
                for b =(1:rows);
                    % checks each corner of a room to see if it is in range
                    % of the room center
                    for  c = (6:2: columns-1);
                        points = [ room_data(start_index,3)...
                                   room_data(start_index,4);
                                   room_data(b,c)...
                                   room_data(b,c+1);
                                    ];
                        distance =  pdist(cell2mat(points));
                        % room id appending to cell array if it is with in
                        % range of the known links
                        if distance <=radius;
                            potentials{ end +1} = room_data{b,1};
                            break;
                        end
                    end
                end
                % make sure the potential rooms are inclusing only once
                potentials = unique(potentials);
                %condition to set the initial potential list with
                %subseqent iterationg finding the intersection of the rooms
                if trigger;
                   temp_candidates = potentials;
                   trigger = 0;
                else
                    temp_candidates = intersect(temp_candidates,potentials);
                end
            end
        end
        % adds unknown node int to candidate list for delimination
        candidates{end+1} = unknown_nodes(1,index);
        if isempty(temp_candidates)
            temp_candidates = transpose(room_data(:,1));
        end
        % concat the candidate list with the rooms the node may be in
        candidates = cat(2,candidates,temp_candidates);
        
        % updates variable used to keep track of position is matrices
        offset = offset +2;
        index=index+1;

        % reset the potential and tempo candidate list to have clean data
        % for each unknown node
        potential = {};
        temp_candidates = {};
    end
    % pre allocated array to seperate potential room list for unknown nodes
    % housing keeping performed for easy human interpretation
    can_Table = cell(length(room_data)+1,length(unknown_nodes));
    col = 1;
    index = 1;
    % processes potential room list for easy interpretation with room list
    % in rows and the for row of each column being the unknown node
    for a = (1:length(candidates));
        if (col<length(unknown_nodes)) & (candidates{1,a}==unknown_nodes(1,col+1));
            index =1;
            col = col+1;
            can_Table{index,col} = candidates{1,a};
            
        else
            can_Table{index,col}= candidates{1,a};
        end
        index = index+1;
    end
%     test output at this point in function
%     can_Table
    candidates = {};
    potentials = {};

    [row, col] = size(unknown_links);
    % this does pretty much the same thing as the above  nested loop but using
    % the unknown node as the starting location to the known nodes outer
    % loop is used to keep track of the current unknown node being checked
    for offset = (1:length(unknown_nodes));
        candidates{ end +1} = can_Table{1,offset};
        b=2;
        % used to iterate through potential room list previously generated
        while ~(isempty(can_Table{b,offset}))&&b<=row;
            start_index = find(ismember(room_data(:,1),can_Table{b,offset}));
            link_total =0;
            % iterates though unknown links Table pulling data from unknown
            % to known links
            for c = (1:row);
                % conditional so only currently being check unknown nodes
                % are checked p
                if (can_Table{1,offset} == unknown_links{c,1});
                    end_index = find(strcmp(room_data(:,1),unknown_links(c,4)));
%                     room_data{start_index,1}
%                     room_data{end_index,1}
                    radius= get_distance( max(unknown_links{c,3}), room_data(start_index,1), room_data(end_index,1));
                    % skip the distance check if thelink is to another
                    % unknown node
                    if ~isempty(end_index);
                        link_total = link_total +1;
                        for  d = (6:2: columns-1);
                            points = [ room_data(start_index,3)...
                                       room_data(start_index,4);
                                       room_data(end_index,d)...
                                       room_data(end_index,d+1);
                                        ];
                            % link distance calculated using above matrix
                            distance =  pdist(cell2mat(points));
                            % adds the room as a potential for the curent
                            % unknown node
                            if distance <=radius;
                                potentials{ end +1} = room_data{start_index,1};
                                break;
                            end
                        end
                    else
                        continue
                    end
                end
            end
            % room is added to candidates if it exists potential reset for
            % next iteration
            if ~isempty(potentials);
                potentials = unique(potentials);
                temp_candidates{end+1} = potentials{1,1};
                potentials = {};
            end
            b = b+1;
        end
        % added to final candidate list after all links are checked per
        % node testing
        
        if length(temp_candidates)>1;
            for l = (1:length(temp_candidates));
                candidates{end+1} =temp_candidates{1,l};
            end
        else
            for l = (2:length(can_Table(:,offset)));
                if isempty(can_Table{l,offset})
                    break;
                end
                candidates{end+1} = can_Table{l,offset};
            end

        end

        % resets the temps candidate array
        temp_candidates={};
    end
    
    can_Table = cell(length(room_data)+1,length(unknown_nodes));
    col = 0;
    % processes the  data created frem the previos loop processing for easy
    % human interpretation
    for a = (1:length(candidates));
       if ~iscellstr(candidates(1,a))
            col = col +1;
           
           index =1;
            can_Table{index,col} = candidates{1,a};
            index = index +1;
       else
            can_Table{index,col} = candidates{1,a};
            index = index +1;
        end
    end
%     Test output code
%      can_Table
    
   
    [row, col] = size(can_Table);
    update_prob = {};
    % this processes the potential room lists and sets the prior
    %  probability of the assuming random distribution of nodes 

    for col = (1:col);
        prob_Table = cell(1,2);
        tmp_prob_Table = set_prob(room_data, known_nodes_data);
        prob_Table{1,1}=can_Table{1,col};
        str = [];

        % add the rooms to a string array

        for k = (2:row)
            if isempty(can_Table{k,col});
                break;
            else
                str = [str;can_Table(k,col)];
            end
        end
%         if isempty(str)
%             str =
%         end
        % get rooms the node is not in
        not_in = setdiff(tmp_prob_Table(:,1),str(:,1));
        not_in = union(not_in,known_node_id);
        %sets the probability of rooms nod eis not in to zero
        for l = (1:length(not_in));
            index = find(ismember(tmp_prob_Table(:,1),not_in{l,1}));
            tmp_prob_Table{index,2} = 0;
        end
        % call to normalize function to get normalized room probability
        tmp_prob_Table = normalize(tmp_prob_Table, known_nodes_data, not_in,room_data);
        % concat Tables verticall for each uknown node
        prob_Table = cat(1,prob_Table,tmp_prob_Table);
        update_prob = cat(1,update_prob,prob_Table);
    end


    % This is used to remove the known nodes and their values from the
    % probability Table previously generated
    stripped = [];
    for a = (1:length(update_prob));
        if iscellstr(update_prob(a,1))
            count = length(find(ismember(known_nodes_data(:,2),update_prob(a,1))));
            update_prob{a,2} = update_prob{a,2} -count;
        else
            update_prob{a,1} = num2str(update_prob{a,1});
        end 
        if update_prob{a,2} ==0 | isempty(update_prob{a,2});
            continue
        else
            stripped= [stripped; update_prob(a,1) update_prob(a,2);];
        end
    end
    % sets the variable to be returned by this function call
    update_prob=stripped;
end