function [ prob ] = set_prob( data_rooms, locations )
%This function created a matrix to display probabilities associated with a
%room
    
    % created interation variables   
    [k d] = size(locations);
    n =  length(data_rooms);
    % initialize probability table
    prob = cell(n,2);
    % sets sum to zero for total area
    sum = 0;
    
    %iterates through table inserting room id and room area, area is added
    %to sum total will be used toi calculate init probability distribution
    for i = (1:n);
        prob{i,1}= data_rooms{i,1};
        prob{i,2} = (data_rooms{i,4}*data_rooms{i,5});
        sum = sum + prob{i,2};
    end
    
    % calculates and assigns probability based on room area
    for i = (1:n);
        prob{i,2} = prob{i,2}/sum;
    end
    
    % re interate through table finding known node locations and setting
    % probablity by incrementing and rounding down to account for multi
    % room nodes
    if isempty(locations)
        return 
    end
    for j = (1:k);
        for i = (1:n);
            if strcmp(locations{j,2},prob{i,1});
                prob{i,2} = floor(prob{i,2}+1);
                break;
            end
        end
    end
    
    % call to normalize function to adjust initial values after known node
    % assignment
%     prob = normalize(prob, locations);
end

