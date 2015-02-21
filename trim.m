function [ prob ] = trim( prob, known,centered, rssi_data )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    
    k = length(rssi_data);
    j = length(known);
    p = length(prob);
    known_row = known{1,1}+1;
    data = cell(length(prob),2);
  
    index =1;
    for n = (known_row:k);
        for i = (1:k);
           data{index,1} = cat(2,data{1,1}, rssi_data{n,i});   
        end
        index = index+1;
    end
    for i = (1:j);
        data{i,1} = distance_mean(data{i,1}); 
    end
 ind=1;
    for k = (1:j);
        current_node = known{k,2};
        dist_from_curr = data{k,1};
        
         for i =(1:length(prob));
             if  strcmp(current_node,prob{i,1});
                 cur_node_row = i;
                 break;
             end
         end
         
        cur_x = known{k,3};
        cur_y = known{k,4};
         cur_wid = centered{cur_node_row,4}/2;
         cur_hei = centered{cur_node_row,5}/2;
        % clears east and west      
         x_min = cur_x - dist_from_curr;
         x_max = cur_x + dist_from_curr;
         y_min = cur_y - cur_hei;
         y_max = cur_y + cur_hei;
       
        
%         length(prob);
        
         for i =(1:length(prob));
            if centered{i,2}>x_min && centered{i,2}<x_max && centered{i,3}>y_min && centered{i,3}<y_max; 
                 data{ind,2}=centered{i,1};
%                  data{ind,2};
             
                 ind = ind+1;
            end
         end
        
         % north 2 south
         
          x_min = cur_x - cur_wid;
         x_max = cur_x + cur_wid;
         y_min = cur_y - dist_from_curr;
         y_max = cur_y + dist_from_curr;
       
        
%         length(prob);
        
         for i =(1:length(prob));
            if centered{i,2}>x_min && centered{i,2}<x_max && centered{i,3}>y_min && centered{i,3}<y_max; 
                 data{ind,2}=centered{i,1};
%                  data{ind,2}
             
                 ind = ind+1;
            end
         end
            
         
    end
    % code works til here
    
    
    for i = (1:ind-1);
       index = find(ismember(prob(:,1),data{i,2}));
        prob{index,2} = 0;
    end
    
    for i = (1:length(known));
       index = find(ismember(prob(:,1),known{i,2}));
       prob{index,2} = prob{index,2} + 1;
    end
    prob = normalize(prob,known);
%     data
%     prob = data;
end

