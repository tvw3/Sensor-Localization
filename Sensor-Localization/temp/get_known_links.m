function [ link_array ] = get_known_links(data_nodes, data_rssi)
% Organizations known link information into a cell for easy lookup

    % gets total known node total and allocations rows based upon that
    length_known = length(data_nodes);
    data_array = cell(length_known^2, 5);
    index =1;

    % outer loop that interates though the rows of the known matrix
    for i = (1: length_known);
        % sets variables that are used in for organization
        start_node = data_nodes{i,1};
        room_name  = data_nodes{i,2};
        
        % inner loop interates though row designated by start node
        % inserting house keeping variables
        for n = (1:length(data_rssi));            
            data_array{index,1} = room_name;
            data_array{index,2} = start_node;
            data_array{index,3} = n-1;
            index = index+1;
        end
    end
    
    % resets index for next data insertion loop
    index = 1;
    % Iterates length of array adding rssi datasets to 4th column
    while index<=length_known*(length(data_rssi))
        % sets row based on node number plus offset
        row = data_array{index,2}+1;
        % adds rssi data sets to link table 
        for i =(1:length(data_rssi));
            % condition to ignore empty main diagonals
            if row ~= i;
                data_array{index,4} = data_rssi{row,i};
            end
            % increment to account for added data
            index=index+1;
        end
    end
    
    % resets index
    index = 1;
    % outer look interates though data table
    while index<=length_known*(length(data_rssi));
        if isempty(data_array{index,4});
            index = index +1;
        else
            % finds first location for a given node id in data_nodes
            start_index = find(ismember(data_nodes(:,2),data_array{index,1}),1);
            end_node = data_array{index,3};
            found=0;
            for i = (1:length_known);
                if data_nodes{i,1} == end_node;
                    end_index = i;
                    found = 1;
                    break;
                end
            end

%             end_index = find(ismember(data_nodes(:,1),data_array{index,3}),1)

            % conditional to make sure it is not the same node
%             if data_array{index,2} ~=data_array{index,3};
                    %sets end node and boolean
%                     found = 0;

                    %loops though known node locations getting index if node is
                    % found break loop on success

                % when link is found to be between known nodes the link
                % distance is calculated
                if found;
                    % creates a matrix based on look up of values from node data 
                    points = [ data_nodes(start_index,3)...
                               data_nodes(start_index,4);
                               data_nodes(end_index,3)...
                               data_nodes(end_index,4);
                                ];
                    % link distance calculated using above matrix
                    distance =  pdist(cell2mat(points));

                    % insertion distance calculated by pdist
                    data_array{index,5} = distance;
                end
            index=index+1;
                %             end
        end
        % increments index to offset
    end
    % assigns organized table to descriptive variable
    link_array = data_array;
end

