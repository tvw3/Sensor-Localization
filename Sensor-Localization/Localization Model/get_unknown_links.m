function [ unknown_links ] = get_unknown_links( known_links,rssi_data)
%return 5 column cell array of [start || end || rssi set || distance || end room id ]

    % get set of end node id integer
    end_nodes = [];
    end_nodes = [end_nodes known_links{:,3};];

    % get set of start node id integer
    start_nodes = [];
    start_nodes = [start_nodes known_links{:,2};];

    % get unknown links int id
    unknown_nodes = setdiff(end_nodes,start_nodes);

    unknown_links = [];
    
    % generates the return table by insertion at desired locations
    for n = (1:length(unknown_nodes));
        row = unknown_nodes(1,n) +1;
        for m = (1:length(rssi_data));
            if ~(isempty(rssi_data{row,m}));
                index = find([known_links{:,2}]==m-1,1);
                if ~isempty(index);
                    index = known_links{index,1};
                else
                    index = {[]};
                end
                
                unknown_links = [unknown_links; row-1 m-1 rssi_data(row,m)...
                                        index;];
            end
        end
    end
end

