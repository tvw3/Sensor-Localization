function [ x,y ] = set_map( x_lab, y_lab, Title, table , count)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
    [rows cols] = size(table);
    
    for i = 1:rows;
        set_y = zeros(1,count(i,2)-1);
        set_x = zeros(1,count(i,2)-1);
        k=2;
        j=1;
        while table(i,k)~=0&&k<=count(i,2);
           set_y(j) = table(i,k);
           set_x(j) = table(i,1);
           k = k+1;
           j = j+1;
        end
        x = plot(set_x, set_y, '.');
        set(x, 'MarkerSize', 0.05*(count(i,2)));
        hold on;
    end
    xlim([0,230]);
    title(Title);
    ylabel(y_lab);
    xlabel(x_lab);
end

