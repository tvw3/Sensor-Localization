function [ model] = set_model( known_links)
% Created a polynomial based distance model based upon known dataset
%   returns a matrix array of coefficients for a second degree polynomial
    
    % splits input cell array by rssi and distance columns
    rssi = known_links(:,4);
    dist = known_links(:,5);
    len = length(dist);

    % finds empty cells for removal of entries
    empty_rssi = cellfun('isempty', rssi);
    empty_dist = cellfun('isempty', dist);
    
    % iterates distance array emptying rssi corresponding index as distance
    % can not be modeled on unknown distance values also remove zero
    % distance values resulting from multiple nodes in a room
    for i = (1:len);
       if dist{i,1} ==0;
           dist{i,1} = [];
           rssi{i,1} = [];
       end
    end
    
    % iterates rssi array emptying distance corresponding index as distance
    % can not be modeled on unknown rssi values
    for i = (1:len);
        if empty_rssi(i,1)==1;
            dist{i,1} = [];
        end
        if empty_dist(i,1);
            rssi{i,1} = [];
        end
    end
    
    % striped the empty cell from dist and rssi arrays
    rssi = (rssi(~cellfun('isempty', rssi)));
    dist = (dist(~cellfun('isempty', dist)));

    % generates inserts the mean of the rssi for a corresponding distance
    for i = (1:length(rssi));
         c = cell2mat(rssi(i,1));
        rssi{i,1} =  mean(c);
    end
    
    % coverts cell array to matrix
    rssi = cell2mat(rssi);
    dist = cell2mat(dist);

    % generates an array containing unique link distances and allocates
    % matrix for corresponding rssi
    unique_dist = unique(dist);
    unique_rssi = zeros(length(unique_dist),1);
    
    % outer loop to iterate the length of unique distance values 
    for i = (1:length(unique_dist));
        % variables to reaverage rssi to accout for bidirectional links
        sum = 0;
        count = 0;
        % iterations through rssi adding corresponding values
        for j = (1:length(rssi));
            if unique_dist(i,1)==dist(j,1);
                sum = sum + rssi(j,1);
                count= count +1; 
            end
        end
        % averages same link values and assigns
        unique_rssi(i,1) = sum/count; 
    end
    
    % sorted arrays and adds zeros to bound polynomial
    rssi = flip(sortrows([ zeros(1); unique_rssi]),1);
    distance = sortrows([ zeros(1); unique_dist]);
   
    % sets coefficients returned by polyfit function of degree two
    model = polyfit( (rssi),distance, 1);    
end 

