function [ path, unknown_list ] = get_path( unknown_links , path )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    for a = 1:length(unknown_links)
       unknown_links{a,1}= num2str(unknown_links{a,1});
       unknown_links{a,2}= num2str(unknown_links{a,2});
    end

    known_nodes = setdiff(unknown_links(:,2),unknown_links(:,1));
    unknown_nodes = setdiff(unknown_links(:,1),known_nodes);

    unknown_index = unknown_nodes;
    for a = 1:length(unknown_index)
        unknown_index{a,1} = find(ismember(unknown_links(:,1),unknown_index{a,1}),1);
    end
    
%     path_possible = perms(unknown_nodes);
%     [path_row, path_col] = size(path_possible);
% 
%     
%     for a = 1:path_row
%         found = 0;
%         for b = 1:(path_col-1)
%             first_node_start = find(ismember(unknown_nodes(:,1), path_possible{a,b}));    
%             first_node_end = first_node_start+1;
%             if first_node_end>length(unknown_nodes)
%                 first_node_end = length(unknown_links);
%             else
%                 first_node_end = unknown_index{first_node_end,1}-1;
%             end
%             first_node_start = unknown_index{first_node_start,1};
%             second_node_start = find(ismember(unknown_nodes(:,1), path_possible{a,b+1}));    
%             second_node_end = second_node_start+1;
%             if second_node_end>length(unknown_nodes)
%                 second_node_end = length(unknown_links);
%             else
%                 second_node_end = unknown_index{second_node_end,1}-1;
%             end
%             second_node_start = unknown_index{second_node_start,1};
%     
%             start_flag = 0;
%             end_flag = 0;
%             start_indices = find(ismember(unknown_links(:,2),path_possible{a,b}));
%             end_indices = find(ismember(unknown_links(:,2),path_possible{a,b+1}));
%             for c = 1:(length(end_indices))
%                 if end_indices(c,1)<=first_node_end && end_indices(c,1)>=first_node_start
%                     end_flag=1;
%                     break;
%                 end        
%             end
%             start_flag;
%             end_flag;
%             if end_flag==0 % || end_flag==0
%                 break;
%             elseif (b+1)==path_col
%                 found =1;
%                 path = path_possible(a,:);
%                 break;
%             end
%             
%         end
%         if found==1
%             break;
%         end
%     end
% path
    unknown_only = [];
%     unknown_links
    done = zeros(length(unknown_links),1);
    for a = 1:length(unknown_links)
        start_node = unknown_links(a,1);
        end_node = unknown_links(a,2);
        for b = 1:length(unknown_links)
            if done(b,1)==0 & strcmp(unknown_links(b,2),start_node)& strcmp(unknown_links(b,1),end_node)
                unknown_links{a,3}= cat(2,unknown_links{a,3},unknown_links{b,3});
                unknown_links{b,3}= unknown_links{a,3};
                done(a,1)=1;
                done(b,1)=1;
            end
        end
    end
%     unknown_links
    for a = 1:length(path)
       for b = 1:length(unknown_links) 
%             if strcmp(

                if strcmp(unknown_links(b,1),path(1, a)) & ~isstr(unknown_links{b,4})
                     unknown_only= [unknown_only; unknown_links(b,:)];
%                     
                end
%             end
        end
    end
    unknown_list = unknown_only;
end

