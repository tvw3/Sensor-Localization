function [ prob ] = normalize( prob, known)
%This is a helper function that normalizes an input matrix
%   using known node and probability matrices 
    
    % sets length of of input matrices for interation
    k = length(known);
    n =  length(prob);
    % loop that sums the values of the probability column
    sum = 0;
    for i = (1:n);
        sum = prob{i,2} + sum;
    end
    % creates factor to normalize data after removing known node weights
    % from table
    multiplier = 1/(sum-k);
    
    % Iterates through probability table using multiplier to normalize
    % rooms not known to house nodes
    for i = (1:n);
        if prob{i,2} <1;
            prob{i,2} = prob{i,2} * multiplier; 
        end
    end
end

