function Jlocate(node,rssi,node_locations)

clc;


known = load_known_nodes(node_locations);
rssiData = load_rssi(rssi);
roomData = load_room_data('rooms.csv');


% known = load_known_nodes('node_locations.csv');
% rssiData = load_rssi('rssi_data_trial_1.csv');
% roomData = load_room_data('rooms.csv');

%Just used to get the index of the known node
for i = 1: size(roomData)
    rooms(i) = roomData(i,1);
end

for i = 1 : size(known)
    
    %Get the index of the known node to get the known node information
    temp = find(ismember(rooms, cell2mat(known(i,2))));
    
    %Get the x and y of the known node
    x = cell2mat(roomData(temp, 2)) + cell2mat(roomData(temp,4))/2;
    y = cell2mat(roomData(temp, 3)) + cell2mat(roomData(temp,5))/2;
    %Used in calculating the room intersections
    center = [x, y];
    
    cnt = 0;
    for j = 1 : size(roomData)
        
        %Determine the value of the known node
        knownRSSI = cell2mat(rssiData(cell2mat(known(i,1)) + 1,node + 1));
        %Get the distance from the known node to the unknown node
        dist = get_distance(knownRSSI, -42,3,2);
        
        %if the current node we are checking is a known node or NaN
        %distance (ie can't communicate) skip this iteration
        if (cell2mat(known(i,1)) == j || isnan(dist))
            continue;
        end
        
        %Get the room X,Y and Width, Height
        rX = cell2mat(roomData(j,2));
        rY = cell2mat(roomData(j,3));
        rW = cell2mat(roomData(j,4));
        rH = cell2mat(roomData(j,5));
        
        %Get the four corner points of each room
        a = [rX, rY];
        b = [rX, rY + rH];
        c = [rX + rW, rY + rH];
        d = [rX + rW, rY];
        
        %Check if the circle intersects any of the rooms' walls
        if (intersectCircle(a,b,center,dist) || intersectCircle(b,c,center,dist) || intersectCircle(c,d,center,dist) || intersectCircle(d,a,center,dist))
            cnt = cnt + 1;
            possibleRooms(3*i-2,cnt) = known(i,1);
            possibleRooms(3*i-1,cnt) = roomData(j,1);
            
            %Update the % chance that the node is in that specific room
            %Currently each room is given an equal chance
            for k = 1: cnt
                possibleRooms(3*i,k) = mat2cell(1/cnt,1);
            end
        end
        
        
    end
    
    
    
    
    
end
possibleRooms
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