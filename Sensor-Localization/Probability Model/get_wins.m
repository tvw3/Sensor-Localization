function output = get_wins(i,k,known,rssi,model)
% i = unknown node_id, IE: 6
% k = room number, IE: 'R234'
% known - known nodes, IE: 'node_locations.csv'
% rssi - rssi
% model - distance model
    
%     get room x,y location and width and height
    room = cell2mat(k(1,2:end));
    rX = room(1);
    rY = room(2);
    rW = room(3);
    rH = room(4);
%     get room cornerc tl = topleft, etc...
    tl = [rX, rY];
    tr = [rX + rW, rY];
    bl = [rX, rY - rH];
    br = [rX + rW, rY - rH];
    
%   Take the average f all rssi data
    for i=1:length(rssi)
        rssi{i} = mean(rssi{i});
    end
    
%     convert the rssi[] into distance[]
    distance = [];
    for i=1:length(rssi)
        if isnan(rssi{i})
            continue;
        else
            distance(i) = getdistance(rssi{i}, model);
        end
    end
    
%     where all the magic happens
    knd_ids = cell2mat(known(:,1));
    win = 0; %count for when a circle falls into room K
    lose = 0;%count for when a circle doesn't fall into room K
    for i=1:length(distance) %iterate over distance[]
        for j=i:length(knd_ids); %iterate over known_nodes[] sort of
            if knd_ids(j)==i+1 %when a known_node_id matches a distance in distance[]
                %setup for circle creation
                dist = distance(i);
                x = cell2mat(known(j,3));
                y = cell2mat(known(j,4));
                center = [x,y];
                % if circle intersects any walls of K add to win
                if (intersectCircle(tl,tr,center,dist) || intersectCircle(tr,br,center,dist) || intersectCircle(br,bl,center,dist) || intersectCircle(bl,tl,center,dist))
                    win = win + 1;
                else %otherwise add to lose
                    lose = lose +1;
                end
            end
        end
    end
    
    
    output = [win,lose];
end


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
