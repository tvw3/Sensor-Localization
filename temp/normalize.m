function [ prob ] = normalize( prob, known, known_not, rooms)
%This is a helper function that normalizes an input matrix
%   using known node and probability matrices 
    rooms;
    % sets length of of input matrices for interation
    [k  m] = size(known);
    n =  length(prob);
    % loop that sums the values of the probability column
%     known;
%     count = length(find(ismember(known(:,2),'R234')));
    
    in = intersect(known_not(:,1), known(:,2));
    rest =  setdiff(known(:,2),in(:,1));
    teamster = union(in,rest);
    
    dummy = {};
    prob;
    prior = set_prob(rooms, dummy);
    
    for d = (1:length(known_not))
       to_zero = find(ismember(prior(:,1), known_not{d,1}));
       prior{to_zero,2} = 0;
    end
    prior;
    
    sum = 0;    
    for i = (1:n);
        sum = prior{i,2} + sum;
    end
    
    
    % creates factor to normalize data after removing known node weights
    % from table
    multiplier = 1/(sum);
    
    for i = (1:n);
        prior{i,2} = prior{i,2} * multiplier; 
    end
    prior;
    
    for m = (1:length(teamster));
        count = length(find(ismember(known(:,2),teamster(m,1))));
        index = find(ismember(prior(:,1),teamster(m,1)));
        prior{index,2} = prior{index,2} +count;
    end
    prob = prior;
 
%     sum = 0;    
%     for i = (1:n);
%         sum = prior{i,2} + sum;
%     end
%     sum
    % Iterates through probability table using multiplier to normalize
    % rooms not known to house nodes
%     for i = (1:n);
%         if prob{i,2} <1;
%             prob{i,2} = prob{i,2} * multiplier; 
%         end
%     end
end

