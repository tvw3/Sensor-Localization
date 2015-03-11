function [ update_prob ] = in_range( known_links ,room_data, known_nodes_data,probability_table,model, unknown_links);
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    end_nodes = [];
    end_nodes = [end_nodes known_links{:,3};];

    start_nodes = [];
    start_nodes = [start_nodes known_links{:,2};];

    known_nodes = unique(start_nodes);
    unknown_nodes = setdiff(end_nodes,start_nodes);
    all_nodes = union(end_nodes,start_nodes);
    
    link_length = (length(all_nodes)-1);


    for j = (1:length(unknown_nodes));
        stuff = cell(link_length,2);
        index =1;

        for i =(1:length(known_links));
            if unknown_nodes(1,j)==known_links{i,3};
                stuff{index,1} = known_links{i,1};
                % change to max with node 1 not present
                stuff{index,2} = max(known_links{i,4});
                index = index +1;
            end
        end
        if j==1;
            table = stuff;           
        else
            table = cat(2,table,stuff);
        end
    end
    
    [m n] = size(table);
    offset = 2;
    while offset <= n;
        for k = (1:m);
           if ~(isempty(table{k,offset}));
               table{k,offset} = getdistance(table{k,offset},model);      
           end
        end
        offset = offset +2;
    end
    [ rows columns] = size(room_data);
    
    offset = 2;
    candidates = {};
    index =1;
    while offset <= n;
        trigger = 1;
%          potentials = {};
        for a = (1:m);
            potentials = {};

            if ~(isempty(table{a,offset}));
                
                start_index = find(ismember(room_data(:,1),table(1,offset-1)));
                radius = table{a,offset}*1.20;
                for b =(1:rows);

                    for  c = (6:2: columns-1);
                        c;
                        points = [ room_data(start_index,3)...
                                   room_data(start_index,4);
                                   room_data(b,c)...
                                   room_data(b,c+1);
                                    ];
                        % link distance calculated using above matrix
                        distance =  pdist(cell2mat(points));
%                         if strcmp(room_data{b,1},'R235');
%                             
%                             points
%                             distance
%                             radius
%                         end
                        if distance <=radius;
                            potentials{ end +1} = room_data{b,1};
                            break;
                        end
                    end
                end
                potentials = unique(potentials);

                if trigger;
                   temp_candidates = potentials;
                   trigger = 0;
                else
                    temp_candidates = intersect(temp_candidates,potentials);
                end
                    
            end
        end
        candidates{end+1} = unknown_nodes(1,index);
        index=index+1;
        candidates = cat(2,candidates,temp_candidates);
        offset = offset +2;
        potential = {};
        temp_candidates = {};
    end
  
    can_table = cell(length(room_data)+1,length(unknown_nodes));
    col = 1;
    index = 1;
    for a = (1:length(candidates));
        if (col<length(unknown_nodes)) & (candidates{1,a}==unknown_nodes(1,col+1));
            index =1;
            col = col+1;
            can_table{index,col} = candidates{1,a};
            
        else
            can_table{index,col}= candidates{1,a};
        end
        index = index+1;
    end
    
    offset = 1;
    update_prob = can_table;
    candidates = {};
    potentials = {};


[row col] = size(unknown_links);
for offset = (1:length(unknown_nodes));
      candidates{ end +1} = can_table{1,offset};
     b=2;

    while ~(isempty(can_table{b,offset}));
%        temp_candidates = {};
        
        start_index = find(ismember(room_data(:,1),can_table{b,offset}));
        link_total =0;
        for c = (1:row);    

            if (can_table{1,offset} == unknown_links{c,1});
               end_index = find(strcmp(room_data(:,1),unknown_links(c,5)));
            radius=unknown_links{c,4}*1.20;
            if ~isempty(end_index);
                link_total = link_total +1;
                for  d = (6:2: columns-1);
%                     d=12;
                    points = [ room_data(start_index,3)...
                               room_data(start_index,4);
                               room_data(end_index,d)...
                               room_data(end_index,d+1);
                                ];
                    % link distance calculated using above matrix
                    distance =  pdist(cell2mat(points));
                    if distance <=radius;
        %                 link_count = link_count+1;
                        potentials{ end +1} = room_data{start_index,1};
                        break;
%                         if link_total == 5;
%                            potentials 
%                         end
                    
                    end
                    
                end
            else

                continue
            end
%                 potentials = unique(potentials);        
            end
        end
        if length(potentials) >0
            offset;
            can_table{b,offset};
            length(potentials);
            potentials = unique(potentials);
            temp_candidates{end+1} = potentials{1,1};
        else    
        end
        b = b+1;
        potentials = {};
    end
    if ~isempty(temp_candidates);
        for l = (1:length(temp_candidates));
            candidates{end+1} =temp_candidates{1,l};
        end
        
%         temp_candidates = unique(temp_candidates)
%         candidates(2,candidates, temp_candidates);
    end
    temp_candidates={};
end

    can_table = cell(length(room_data)+1,length(unknown_nodes));
    col = 0;
%     index = 1;
    
    for a = (1:length(candidates));
       if ~iscellstr(candidates(1,a))
            col = col +1;
           
           index =1;
            can_table{index,col} = candidates{1,a};
            index = index +1;
       else
            can_table{index,col} = candidates(1,a);
            index = index +1;
        end
    end
    
   
 [row col] = size(can_table);
% tab= {};
% potentials = {}

% temp = can_table;
% temp([1;]) = [];
% static = set_prob(room_data, known_nodes_data);
update_prob = {};
for col = (1:col);
    prob_table = cell(1,2);
    tmp_prob_table = set_prob(room_data, known_nodes_data);%static;%probability_table;
    prob_table{1,1}=can_table{1,col};
    str = [];
    
    
    for k = (2:row)
        if isempty(can_table{k,col});
            break;
        else
            str = [str ;can_table{k,col}];
        end
    end
    not_in = setdiff(tmp_prob_table(:,1),str(:,1));

    for l = (1:length(not_in));
        index = find(ismember(tmp_prob_table(:,1),not_in{l,1}));
        tmp_prob_table{index,2} = 0;
    end
%     for z = (1:length(known_nodes_data));
%         index = find(ismember(tmp_prob_table(:,1),known_nodes_data{z,2}));
%         tmp_prob_table{index,2} = tmp_prob_table{index,2}+1;
%     end
    tmp_prob_table = normalize(tmp_prob_table, known_nodes_data, not_in,room_data);
    prob_table = cat(1,prob_table,tmp_prob_table);
    update_prob = cat(1,update_prob,prob_table);
end

stripped = [];
for a = (1:length(update_prob));
    if update_prob{a,2} ==0 | isempty(update_prob{a,2});
        continue
    else
        update_prob(1,1);
        stripped= [stripped; update_prob(a,1) update_prob(a,2);];
    end
end
    update_prob=stripped;
end