function cleaned = clean_nodes(known, nodes_to_locate)
    %Nodes to locate will either be a 1 dimensional vector or a scalar
    %known is a cell array containing the known nodes and locations
    
    cleaned = known;
    %Not sure if nodes will be sorted, so a linear search is applied
    %not optimal, but we are dealing with a small set of data, so it
    %shouldn't be a problem
    %start at the end of the list and work backwards to avoid index issues
    for i = (length(known):-1:1);
        %check if the known node is in the list of nodes to locate
        if(any(known{i,1}==nodes_to_locate));
            %yes, keep track of the row to delete
            cleaned(i,:) = [];
        end
    end
end

