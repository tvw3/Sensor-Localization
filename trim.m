function [ prob ] = trim( prob, known,centered, rssi_data ,model )
% Trim is a function that makes inferences about solution domain
%   based upon the distance model and known node locations,

    % set iterator variables
    k = length(rssi_data);   
    j = length(known);
    index =1;
    
    % allocation of 2 column cell array to hold room string and
    % corresponding probablity used as a workspace prior to final assignment
    data = cell(length(prob),2);
    
    %outer loop to interate through known node rows
    while index <= j;
        % sets known row to node id taken from node_location
        % offset by one to account for zero node
        n = known{index,1}+1;   

        % inner loop iterates through row in rssi_data matrix
        % indicated by n 
        for i = (1:k);
            % Concatenates rssi values of nth row and stores them in 
            % first column of and row marked by index
            data{index,1} = cat(2,data{index,1}, rssi_data{n,i});
        end
        % gets a conservative estimate of the node link distance
        % to the closest connected node
        data{index,1} = getdistance((mean(data{index,1})*0.35), model);
        
        % Increment index for next loop 
        index = index+1;
    end
    
    % sets new index variable
    ind=1;
    % outer loop to interate through rows of known matrix
    for k = (1:j);
        % gets first known node string id
        current_node = known{k,2};
        % sets assumed min distance to closest node
        dist_from_curr = data{k,1};
        
        % finds index of known string id in probaility matrix
        for i =(1:length(prob));
            if strcmp(current_node,prob{i,1});
                cur_node_row = i;
            break;
            end
        end
        
        % looks up and sets current node center and dimensions of room
        cur_x = known{k,3};
        cur_y = known{k,4};
        cur_wid = centered{cur_node_row,4}/2;
        cur_hei = centered{cur_node_row,5}/2;
        
        % Sets the North to South bounds of rooms to be removed
        % based on rssi distance to closest node and room dimensions 
        x_min = cur_x - dist_from_curr;
        x_max = cur_x + dist_from_curr;
        y_min = cur_y - cur_hei;
        y_max = cur_y + cur_hei;
        
        % iterates through the probability matrix adding string ids to
        % workspace data
        for i =(1:length(prob));
            % conditional for rooms inside boundary
            if centered{i,2}>x_min && centered{i,2}<x_max && centered{i,3}>y_min && centered{i,3}<y_max;
                data{ind,2}=centered{i,1};
                ind = ind+1;
            end
        end
        
        % Sets the East to West bounds of rooms to be removed
        % based on rssi distance to closest node and room dimensions 
        x_min = cur_x - cur_wid;
        x_max = cur_x + cur_wid;
        y_min = cur_y - dist_from_curr;
        y_max = cur_y + dist_from_curr;

        % iterates through the probability matrix adding string ids to
        % workspace data
        for i =(1:length(prob));
            % conditional for rooms inside boundary
            if centered{i,2}>x_min && centered{i,2}<x_max && centered{i,3}>y_min && centered{i,3}<y_max;
            data{ind,2}=centered{i,1};
            ind = ind+1;
            end
        end
    end % End of outer For loop
    
    % Iterates though the workspace array and replacing the corressponging
    % probability index with 0, to remove from the potential list
    for i = (1:ind-1);
        for j = (1:length(prob));
            if strcmp(prob{j,1},data{i,2});
                index = j;
                break;
            end
        end
        prob{index,2} = 0;
    end
        
    % Reinterates through list adding known locations back to prob list
    for i = (1:length(known))
        for j = (1:length(prob));
            if strcmp(prob{j,1},known{i,2});
                index = j;
                break;
            end
        end
        count = 0;
        for m = (1:length(known))
            if strcmp(prob{j,1}, known{m,2})
                count = count +1;
            end
        end
        if count == 1
            prob{index,2} = 1;%; %incremented to account for multi room nodes        
        else
            prob{index,2} = 2;
        end
    end
      
    % function to normalize probability matrix after room removal
    prob = normalize(prob,known);
 end