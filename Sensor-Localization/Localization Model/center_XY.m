function [ data_rooms ] = center_XY( data_rooms )
% Format = RoomID | Center_X | Center_Y | width | height ....
% The rest are X and Y cooridinates of the corners of each room in tho
% order top left, top right, bottom right, and bottom left
% This function take in the cell array returned by load_room_data
%   it centers the XY values based on the width(x) and height(y) of the room

    % iteration variable
    n = length(data_rooms);
    corners = cell(n,8);

    % adjusts x-y of initial room data to room center due to human sanity
    % of hand measuring room locations origin location is the implied
    % intersection of room 237 wall and room 255-261 walls
    
    % iterates through room data matrix
    for i = (1:n);
       % adds top left X Y
       corners{i,1} = data_rooms{i,2};
       corners{i,2} = data_rooms{i,3};
       
       % adds top right X Y
       corners{i,3} = corners{i,1}+data_rooms{i,4};
       corners{i,4} = corners{i,2};
        
       % adds bottom right X Y
       corners{i,5} = corners{i,3};
       corners{i,6} = corners{i,4}-data_rooms{i,5};
        
       % adds bottom left X Y
       corners{i,7} = corners{i,1};
       corners{i,8} = corners{i,6};
       
       % adjusts xy based on measured values
       data_rooms{i,2} = data_rooms{i,2} + (data_rooms{i,4}/2); 
       data_rooms{i,3} = data_rooms{i,3} - (data_rooms{i,5}/2);
    end

    %joins two created cell arrays
    data_rooms = cat(2,data_rooms, corners);
    
end

