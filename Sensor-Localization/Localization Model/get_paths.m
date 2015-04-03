function [ prob_list ] = get_paths( room_data, unknown_links, update_prob )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
   % creates a matrix of all end links from known start nodes
    end_nodes = [];
    end_nodes = [end_nodes unknown_links{:,2}];

    % creates a matrix of all known start nodes
    start_nodes = [];
    start_nodes = [start_nodes unknown_links{:,1}];

    % create matrix of unknown nodes and all_nodes
    known_nodes = setdiff(end_nodes,start_nodes);
    all_nodes = union(end_nodes,start_nodes);
    unknown_nodes = setdiff(all_nodes,known_nodes);
    unknown_nodes(1,:);
    
    indices = {};
    for q =(1:length(unknown_nodes));
        indices {end +1} = find(ismember(update_prob(:,1), int2str(unknown_nodes(1,q))));
    end
    count=0;
    path = [];
    
    unk_2_unk = [];
    [ m n ] = size(unknown_links);
    
    for a = (1:m)
        if isempty(unknown_links{a,5});
           
            unknown_links(a,:)
        end
    end
%     find(ismember(unknown_links(:,1)), int2str(unknown_nodes(1,1))))
%     == find(ismember(int2str(unknown_links(:,2)), int2str(unknown_nodes(1,2))))
%     for x = (indices{1,1}+1:indices{1,2}-1)
%         temp_path = cell(1,4);
%         x_index = find(ismember(room_data(:,1), update_prob(x,1)));
%         temp_path{1,1} = update_prob{x,1};
%         temp_path{1,4} = update_prob{x,2};
%         for y = (indices{1,2}+1:indices{1,3}-1)
%             link_x_index
%             y_index = find(ismember(room_data(:,1), update_prob(y,1)));
%             
%             
%             
%           for z = (indices{1,3}+1:length(update_prob))
%             
%               
%           end
%        end
%     end
end

