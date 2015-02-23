function results = format_results(wins)
%wins - the cell array of rooms and associated wins
    wins
    %need the number of columns to check if we have 1 or 2 unknown nodes
    [rows cols] = size(wins);
    %only one node, simply return data already present
    %convert the first node wins to matrix for easier calculations
    f_node = cell2mat(wins{1}(2:end,2));

    %calculate the total wins for the first node
    f_total = sum(f_node);
    probabilities = f_node / f_total;

    %convert back to cell array for table like view
    wins{1}(2:end,2) = num2cell(probabilities);
    if cols == 1;
        results = wins{1};
    else
        %calculations same as above, except for the second node
        s_node = cell2mat(wins{2}(2:end,2));
        
        s_total = sum(s_node);
        s_probabilities = s_node / s_total;
        
        wins{2}(2:end,2) = num2cell(s_probabilities);
        %setup the table. Needs to hold all data in 
        results = cell(length(wins{2}(2:end,1)) + 2,length(wins{1}(2:end,1)) + 2);
        
        %Set the column and row labels
        results(3:end,1) = wins{2}(2:end,1);
        results(1,3:end) = wins{1}(2:end,1);
        
        %Set corner labels
        results{1,1} = 'X';
        results{1,2} = sprintf('Node#: %d',wins{1}{1,2});
        results{2,1} = sprintf('Node#: %d',wins{2}{1,2});
        
        %calculate and set join probabilies
        for i = (2:length(wins{2}));
            for j = (2:length(wins{1}));
                results{i + 1, j + 1} = wins{2}{i,2} * wins{1}{j,2};
            end
        end
    end
end

