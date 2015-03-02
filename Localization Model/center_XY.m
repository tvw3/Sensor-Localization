function [ data_rooms ] = center_XY( data_rooms )
% This function take in the cell array returned by load_room_data
%   it centers the XY values based on the width(x) and height(y) of the room

    % iteration variable
    n = length(data_rooms);
    
    % adjusts x-y of initial room data to room center due to human sanity
    % of hand measuring room locations origin location is the implied
    % intersection of room 237 wall and room 255-261 walls
    
    % iterates through room data matrix
    for i = (1:n);
       % adjusts xy based on measured values
       data_rooms{i,2} = data_rooms{i,2} + (data_rooms{i,4}/2); 
       data_rooms{i,3} = data_rooms{i,3} - (data_rooms{i,5}/2);
    end

end

