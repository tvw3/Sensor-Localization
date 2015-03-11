function [ unknown_links ] = get_unknown_links( known_links,rssi_data ,model )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    end_nodes = [];
    end_nodes = [end_nodes known_links{:,3};];

    start_nodes = [];
    start_nodes = [start_nodes known_links{:,2};];

    known_nodes = unique(start_nodes);
    unknown_nodes = setdiff(end_nodes,start_nodes);
    all_nodes = union(end_nodes,start_nodes);

    unknown_links = [];
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
                
                unknown_links = [unknown_links; row-1 m-1 rssi_data(row,m)  getdistance(max(rssi_data{row,m}),model) index;];
            end
        end
    end
end

