function [ prob ] = normalize( prob, known, known_not, rooms)
%This is a helper function that normalizes an input matrix
%   using known node and probability matrices 
    
    % sets length of of input matrices for interation
    n =  length(prob);

    % gets information about the known and not known nodes
    in = intersect(known_not(:,1), known(:,2));
    rest =  setdiff(known(:,2),in(:,1));
    teamster = union(in,rest);
    
    % dummy variable to generate a unknown node prior probability table
    dummy = {};
    prior = set_prob(rooms, dummy);
    
    % sets the room known to not contain the node to zero 
    for d = (1:length(known_not))
       to_zero = find(ismember(prior(:,1), known_not{d,1}));
       prior{to_zero,2} = 0;
    end
    
    % sums the probability left in the table
    sum = 0;    
    for i = (1:n);
        sum = prior{i,2} + sum;
    end
    
    
    % creates factor to normalize data after removing known node weights
    % from table
    multiplier = 1/(sum);

    % multiplys the probablity so they sum to 1
    for i = (1:n);
        prior{i,2} = prior{i,2} * multiplier; 
    end
    
    % adds in the known nodes values
    for m = (1:length(teamster));
        count = length(find(ismember(known(:,2),teamster(m,1))));
        index = find(ismember(prior(:,1),teamster(m,1)));
        prior{index,2} = prior{index,2} +count;
    end
    prob = prior;
 
end

