function [ cond_prob can_Table] = get_infer( probabilities, rooms,known_links, unknown_links )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    all_nodes = [unknown_links{:,2} unknown_links{:,1}];
    known_nodes = [known_links{:,2}];
    unknown_nodes = setdiff( all_nodes, known_nodes);
    known_nodes = setdiff(all_nodes,unknown_nodes);

    unknown_index = unknown_nodes;
    
    
    
    
        [prob_row prob_col] = size(probabilities);
        
%     joint_prob =perms(unknown)
%     potential=[]
    temp = probabilities(:,1);

    temp_prob= cat(2,probabilities,temp);

    for a = 1:prob_row
       if isempty(temp_prob{a,2}) 
          node_id = temp_prob{a,3};
          temp_prob{a,2}=0;
       else
           temp_prob{a,3} = node_id;
       end
      
          
    end
    
    
    joint_prob=flip(sortrows(temp_prob,2),1);
    
   roomcount = cell(length(unknown_nodes),2);
    for a = 1:length(roomcount)
        roomcount{a,1} = num2str(unknown_nodes(1,a));
        roomcount{a,2} =length(find(ismember(temp_prob(:,3),roomcount{a,1})))-1;
    end
    
    roomcount = sortrows(roomcount,2);
     roomcount= transpose(roomcount);
    [room_row room_col]=size(roomcount);
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    [path, ordered_unknown_links] = get_path(unknown_links ,roomcount(1,:));

    index = 1;
    ordered_path = [];
    for a = 1:(length(ordered_unknown_links))
        
        if strcmp(path(1,index),ordered_unknown_links(a,1))&strcmp(path(1,index+1),ordered_unknown_links(a,2))
           ordered_path = [ordered_path; ordered_unknown_links(a,:)];
           index= index+1;
           if index==length(path)
                break;
           end
        end
    end

    prob = reorder_prob(path,probabilities);
    
    cond_prob = prob;
    for a = 1:length(path)
        unknown_index(1,a) = find(ismember(prob(:,1),(path(1,a))));
    end

    first_potentials=[];
    [order_row order_col] =size(ordered_unknown_links);
    candidates = []; 
    count = 0;
for z =1:order_row
    start_id = ordered_unknown_links(z,1);
    end_id = ordered_unknown_links(z,2);
    link_rssi = ordered_unknown_links{z,3};

    
    start_index =  find(ismember(prob(:,1),start_id))+1;
    end_index = find(ismember(prob(:,1),end_id))+1;
    candidates =[candidates; prob((start_index-1),1) prob((end_index-1),:)];
%     can_index = length(csndidates);
    for a = start_index:length(prob)
       if isempty(prob{a,2})
            break;
       end
       cond_scalar =1;
       first_room = prob(a,1);
       for b = end_index:length(prob)
            if isempty(prob{b,2})
                break;
            end
            second_room = prob(b,1);
            scalar = get_prob_scalar(rooms,first_room,second_room,link_rssi);
            if scalar>0
                candidates= [candidates; first_room second_room scalar];
            end
       end

    end
    
%     for a = ((unknown_index(1,1)+1):(unknown_index(1,2)-1))

end  
can_Table = candidates;


% [can_row can_col] = size(candidates);
% can_Table = cell(can_row+1,2*length(path));
% path_index=1;
% for a = 1:2:(2*length(path))
%     can_string= {};
%     can_Table(1,a) = path(1,path_index);
%     if path_index==length(path)
%         end_index = can_row;
%     else
%         end_index = find(ismember(candidates(:,1),path(1,path_index+1)),1)-1;
%     end
%     start_index = find(ismember(candidates(:,1),path(1,path_index)),1);
%     path_index =path_index+1;
%     for b =start_index:end_index
%        if ~isempty(candidates{b,3})
%         can_string(end +1) = strcat(candidates(b,1),'|',candidates(b,2));
%         
%         candidates(b,2) = strcat(candidates(b,1),'|',candidates(b,2));
% 
%        end
%     end
%     can_string = unique(can_string);
%     for b = 1:length(can_string)
%         can_Table{b+1,a}=can_string{1,b};
%         can_Table{b+1,a+1}=1;
%     end
%     
% end
% 
% can_Table
%  cond_prob=candidates;
% % cond_prob=first_potentials;
% % count
end
