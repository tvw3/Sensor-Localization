function w= get_walls(room1, room2)

[~,rooms,walls] = xlsread('Walls.csv');

[cols, rows] = size(rooms);

index1 = 0;
for i = 1: cols
    if (strcmp(walls(1,i),room1))
        index1 = i;
    end
end

index2 = 0;
for i = 1: rows
    if (strcmp(walls(i,1),room2))
        index2 = i;
    end
end

w = walls(index1, index2);

end