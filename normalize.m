function [ prob ] = normalize( prob, known)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    k = length(known);
    n =  length(prob);
    
    sum = 0;
    for i = (1:n);
        sum = prob{i,2} + sum;
    end
    
    multiplier = 1/(sum-k);
    %sum = 0;
    for i = (1:n);
        if prob{i,2} <1;
            prob{i,2} = prob{i,2} * multiplier; 
        end
       % sum = prob{i,2} + sum;
    end

end

