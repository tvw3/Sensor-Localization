function [ data_rooms ] = center_XY( data_rooms )
% This function take in the cell array returned by load_room_data
%   it centers the XY values based on the width(x) and height(y) of the room

    n = length(data_rooms);
    
    for i = (1:n);
       data_rooms{i,2} = data_rooms{i,2} + (data_rooms{i,4}/2); 
       data_rooms{i,3} = data_rooms{i,3} - (data_rooms{i,5}/2);
    end

end

