function [ ordered_prob ] = reorder_prob( new_order, prob_list )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    
    ordered_prob = prob_list;

    position = 1;
    for a = 1:length(new_order)
        start_index = find(ismember(prob_list(:,1),new_order(1,a)));
        ordered_prob{position,1} = new_order{1,a};
       ordered_prob{position,2} = []; 
        position = position+1;
        
        for index = start_index+1:(length(prob_list))
            ordered_prob{position,1} =prob_list{index,1};
            ordered_prob{position,2} =prob_list{index,2};
            
            position = position+1;
            if index ==length(prob_list)
                break
            end
            if isempty(prob_list{index+1,2})
                
                break;
            end
        end
    end
end

