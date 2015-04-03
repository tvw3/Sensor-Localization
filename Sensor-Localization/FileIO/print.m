function print(data, nodes, num_nodes, mode)
    for i=1:num_nodes
        i=i*2;
        disp(strcat('node:',num2str(cell2mat(data(1,i)))));
        disp(strcat('probability:', num2str(cell2mat(data(2,i)))));
        disp(strcat('Guess room:', num2str(cell2mat(data(2,i-1)))));
        if mode=='t'
            for j=1:length(nodes)
                x = num2str(cell2mat(nodes(j,1)));
                y = num2str(cell2mat(data(1,i)));
                if strcmp(x,y)==1
                    score = 50;
                    room = num2str(cell2mat(nodes(j,2)));
                    guess_room = num2str(cell2mat(data(2,i-1)));
                    if strcmp(room,guess_room)
                        score = score + 25;
                        if cell2mat(data(2,i)) > .5
                            score = score + 25;
                        else
                            score = score - 25;
                        end
                    else
                        score = score - 25;
                        if cell2mat(data(2,i)) < .5
                            score = score + 25;
                        else
                            score = score - 25;
                        end
                    end
                end
            end
            disp(strcat('real room:', room));
            disp(strcat('score:', num2str(score)));
        end
        disp('----------------------------------------');
    end
end