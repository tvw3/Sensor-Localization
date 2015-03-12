function data = load_room_data(filename)
    %Loads the room data measured from the map in cm, and converts it to
    %feet using the measured scale 1 cm = 12.5 ft
    %Distances are measured from the bottom left corner of the map, which
    %represents the origin of our axis
    scale = 12.5;
    %load the data
    [~, ~, data] = xlsread(filename);
    %remove the column title information
    data(1,:) = [];
    %covert all data from cm to ft based on scale
    for i = (2:5)
        data(:,i) = cellfun(@(x) x * scale, data(:,i), 'un', 0);
    end
end

