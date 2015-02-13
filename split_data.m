function [ table ] = split_data( X,Y, mat_count )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
    rows= length(mat_count);
    m = max(mat_count);
    col = m(1,2);
    table = zeros(rows, col+1);
    for i = 1:rows;
        y=1;
        y_length = length(Y);
        m = mat_count(i,2)+1;
        k=2;
        table(i, 1) = mat_count(i,1);
        while k<= m && y< y_length;
            if X(y)==mat_count(i,1);
                table(i,k)=Y(y);
                k = k+1;
            end
            y=y+1;
        end
    end
    

end

