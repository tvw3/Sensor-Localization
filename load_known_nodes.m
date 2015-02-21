function locations = load_known_nodes(filename,room_data)
    %load the node numbers and locations
    %locations gives us the table with both the node number and room number
    %no need for extra formatting
    [~, ~, locations] = xlsread(filename);
    %check if there are any column headers
    if ischar(locations{1,1})
       %there are, remove them
       locations(1,:) = [];
    end
    %for each node, we need to calculate the position in the center of the 
    %room that is located in and augment our locations matrix with those 
    %coordinates
    %init matrix for center locations
    centers = [];
    for i = (1:length(locations));
       %get the room number for the current known node
       room = locations{i,2};
       %get the index of the room in room data
       ind = find(ismember(room_data(:,1),room));
       %find the center x,y coords for the room
       center_x = room_data{ind,2} + room_data{ind,4} / 2;
       center_y = room_data{ind,3} + (room_data{ind,5} / 2);
       %add to matrix container
       centers = [centers; [center_x, center_y]];
    end
    %augment our node locations with the coordinates for each node
    locations = [locations num2cell(centers)];
end

