function [ prob_scalar ] = get_prob_scalar( rooms,first_room, second_room,rssi )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
%     a=2;
%     b=64;
    index_a = find(ismember(rooms(:,1),first_room));
    index_b = find(ismember(rooms(:,1),second_room));
    
    X1_center = rooms{index_a,2};
    Y1_center = rooms{index_a,3};
    X2_center = rooms{index_b,2};
    Y2_center = rooms{index_b,3};
    count =0;
    direction = orientation(X1_center,Y1_center,X2_center,Y2_center);

    first_top_left = [rooms{index_a,6} rooms{index_a,7}];
    first_top_right = [rooms{index_a,8} rooms{index_a,9}];
    first_bottom_right = [rooms{index_a,10} rooms{index_a,11}];
    first_bottom_left = [rooms{index_a,12} rooms{index_a,13}];
    
    second_top_left = [rooms{index_b,6} rooms{index_b,7}];
    second_top_right = [rooms{index_b,8} rooms{index_b,9}];
    second_bottom_right = [rooms{index_b,10} rooms{index_b,11}];
    second_bottom_left = [rooms{index_b,12} rooms{index_b,13}];
    

if length(direction)==1
        if strcmp(direction,'N') | strcmp(direction,'S')
            
            if strcmp(direction,'N')
                inner_distance = pdist([first_top_right; second_bottom_right]);
                outer_distance = pdist([first_bottom_right; second_top_left]);
            else
                outer_distance = pdist([first_top_left; second_bottom_right]);
                inner_distance = pdist([first_bottom_right; second_top_right]);
            end
                
%             for a = 1:length(rssi)
%                 rssi_distance = get_distance(rssi(1,a),first_room,second_room);
% %                 y =  Y1_center+rssi_distance;
%                 if rssi_distance<=outer_distance & rssi_distance>=inner_distance
%                     count = count +1;
%                 end
%             end
        else
    
            if strcmp(direction,'W')
                inner_distance = pdist([first_top_right; second_top_right]);
                outer_distance = pdist([first_top_left; second_bottom_right]);
            else
                outer_distance = pdist([first_top_right; second_bottom_left]);
                inner_distance = pdist([first_top_left; second_top_right]);
                
            end
        end
%                 
%             for a = 1:length(rssi)
%                 rssi_distance = get_distance(rssi(1,a),first_room,second_room);
% %                 y =  Y1_center+rssi_distance;
%                 if rssi_distance<=outer_distance & rssi_distance>=inner_distance
%                     count = count +1;
%                 end
%             end
                
else
            
       if strcmp(direction,'NW') | strcmp(direction,'NE') 
           
            if strcmp(direction,'NW')
                inner_distance = pdist([first_top_left; second_bottom_right]);
                outer_distance = pdist([first_bottom_right; second_top_left]);
            else
                inner_distance = pdist([first_top_right; second_bottom_left]);
                outer_distance = pdist([first_bottom_left; second_top_right]);
            end
%             for a = 1:length(rssi)
%                 rssi_distance = get_distance(rssi(1,a),first_room,second_room);
%                 if rssi_distance>=inner_distance & rssi_distance<= outer_distance
%                     count = count +1;
%                 end
%             end
       else
            if strcmp(direction,'SW')
                inner_distance = pdist([first_bottom_left; second_top_right]);
                outer_distance = pdist([first_top_right; second_bottom_left]);
            else
                inner_distance = pdist([first_bottom_right; second_top_left]);
                outer_distance = pdist([first_top_left; second_bottom_right]);
                
            end
       end
end
            for a = 1:length(rssi)
                rssi_distance = get_distance(rssi(1,a),first_room,second_room);
%                 i=1;
%                 while rssi_distance >250
%                     i=i+1;
%                     rssi_distance = get_distance(rssi(1,a),first_room,second_room,1*i);                
%                 end
                
%                 y =  Y1_center+rssi_distance;
                if rssi_distance<=outer_distance & rssi_distance>=inner_distance
                    count = count +1;
                end
            end

    prob_scalar = count/length(rssi);
end