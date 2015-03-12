function walls = load_walls(filename)
%filename - file containing wall data
%load the raw data since our table contains strings and ints
[~, ~, walls] = xlsread(filename);
end

