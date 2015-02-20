function locations = load_known_nodes(filename)
%load the node numbers and locations
%locations gives us the table with both the node number and room number
%no need for extra formatting
[~, ~, locations] = xlsread(filename);
end

