function warning = check_nodes(known, nodes_to_locate)
%Checks whether or not a node to be located is already known
%If it is, the user should be warned. Future implementation may contain
%which nodes are causing the warning.
    for i = (1:length(known));
        %check if the known node is in the list of nodes to locate
        if(any(known{i,1}==nodes_to_locate));
            %yes display the warning
            warning = true;
            break;
        end
    end
end

