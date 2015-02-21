function Jlocalize(known,node,rssi,node_locations)

clc;

tNode = node;
j = known; %known node

%Load in all of the data
known = load_known_nodes(node_locations);
rssiData = load_rssi(rssi);
roomData = load_room_data('rooms.csv');


% known = load_known_nodes('node_locations.csv');
% rssiData = load_rssi('rssi_data_trial_1.csv');
% roomData = load_room_data('rooms.csv');


%Determine the value of the known node
knownValue = cell2mat(rssiData(cell2mat(known(j,1)) + 1,tNode + 1));
%Get the distance from the known node to the unknown node
dist = get_distance(knownValue, -43,3,2);

% Control-r to comment, control-t to uncomment

%Just used to get the index of the known node
for i = 1: size(roomData)
    rooms(i) = roomData(i,1);
end
%Get the index of the known node to get the information
temp = find(ismember(rooms, cell2mat(known(j,2))));

%Get the x and y of the known node
x = cell2mat(roomData(temp, 2)) + cell2mat(roomData(temp,4))/2;
y = cell2mat(roomData(temp, 3)) + cell2mat(roomData(temp,5))/2;

%Create the circle
center = [x, y];
% viscircles(int32(center), dist);

cnt = 0;
possibleRooms(1,1) = known(j,2); possibleRooms(1,2) = mat2cell(1,1);
for i = 1: size(roomData);
    %Get the room X,Y and Width, Height
    rX = cell2mat(roomData(i,2));
    rY = cell2mat(roomData(i,3));
    rW = cell2mat(roomData(i,4));
    rH = cell2mat(roomData(i,5));
    
    %Draw rectangles for each room
    rectangle('Position', [rX, rY, rW, rH]);
    %Label each room
    text(rX+rW/2,rY+rH/2,cell2mat(roomData(i,1)),'fontname','helvetica CY',...
    'horizontalalignment','center','fontsize',6,...
    'color','r','fontweight','bold')
    
    %Get the four corner points of each room
    a = [cell2mat(roomData(i,2)), cell2mat(roomData(i,3))];
    b = [cell2mat(roomData(i,2)), cell2mat(roomData(i,3)) + cell2mat(roomData(i,5))];
    c = [cell2mat(roomData(i,2)) + cell2mat(roomData(i,4)), cell2mat(roomData(i,3)) + cell2mat(roomData(i,5))];
    d = [cell2mat(roomData(i,2)) + cell2mat(roomData(i,4)), cell2mat(roomData(i,3))];
    
    %Check if the circle intersects any of the rooms' walls
    if (intersectCircle(a,b,center,dist) || intersectCircle(b,c,center,dist) || intersectCircle(c,d,center,dist) || intersectCircle(d,a,center,dist))
        cnt = cnt + 1;
        possibleRooms(cnt,1) = roomData(i,1);
        
        %Update the % chance that the node is in that specific room
        %Currently each room is given an equal chance
        for k = 1: cnt
           possibleRooms(k,2) = mat2cell(1/cnt,1);
        end
    end
end

%Print out the information
fprintf('Percent chance that Node %d is in:\n', tNode);
fprintf('Room\tChance\n');
for i = 1: size(possibleRooms)
    fprintf('%s\t%f\n', cell2mat(possibleRooms(i,1)), cell2mat(possibleRooms(i,2)));
end
end




%Calculate if a room border intersects the circle
function flag = intersectCircle(a, b, center, radius)

%Check if it intersects at 5 points on the line
p1 = a;
p2 = (b-a)./4;
p3 = (b-a)./2;
p4 = 3 * (b-a)./4;
p5 = b;

%Get the distance from the center of the circle to each point
d1 = sqrt((p1(1) - center(1))^2 + (p1(2) - center(2))^2);
d2 = sqrt((p2(1) - center(1))^2 + (p2(2) - center(2))^2);
d3 = sqrt((p3(1) - center(1))^2 + (p3(2) - center(2))^2);
d4 = sqrt((p4(1) - center(1))^2 + (p4(2) - center(2))^2);
d5 = sqrt((p5(1) - center(1))^2 + (p5(2) - center(2))^2);

%Check if the distance is less than the radius of the circle
%Also check that atleast one end point is outside of the circle
if ((d1 < radius || d2 < radius || d3 < radius || d4 < radius || d5 < radius) && (d1 > radius || d5 > radius))
    flag = 1;
else
    flag = 0;
end
end