% data = output from Prior_Distribution
% nodes_data = output from load_known_nodes
% unknown_nodes_number = the number of unknown nodes we are checking

function pretty_print(data,nodes_data,unknown_nodes_number)
    count = 2;
    node1 = mat2str(cell2mat(data(1,1)));
    for i=1:unknown_nodes_number
        temp_rooms = char('NA', 'NA', 'NA');
        temp_list = [0,0,0];
        while length(num2str(cell2mat(data(count,1)))) > 1 
            temp_num = cell2mat(data(count,2));
            temp_room = cell2mat(data(count,1));
            if temp_num >= 1
                temp_num = temp_num-1;
            end
            if temp_num > temp_list(1)
                temp_list(3) = temp_list(2);
                temp_list(2) = temp_list(1);
                temp_list(1) = temp_num;
                temp_rooms = char(temp_room, temp_rooms(1,:), temp_rooms(2,:));
            elseif temp_num > temp_list(2)
                temp_list(3) = temp_list(2);
                temp_list(2) = temp_num;
                temp_rooms = char(temp_rooms(1,:), temp_room, temp_rooms(2,:));
                
            elseif temp_num > temp_list(1)
                temp_list(1) = temp_num;
                temp_rooms = char(temp_room, temp_rooms(2,:), temp_rooms(3,:));
            end 
            count = count + 1;
            if count == length(data)+1
                break
            end
        end
        
        
        sum = temp_list(1) + temp_list(2) + temp_list(3);
        temp_list(1) = temp_list(1)/sum;
        temp_list(2) = temp_list(2)/sum;
        temp_list(3) = temp_list(3)/sum;
        if i == 1
            first_list = temp_list;
            first_rooms = temp_rooms;
            node2 = mat2str(cell2mat(data(count,1)));
            disp('-----------------------');
            disp(strcat('node:',node1,':', num2str(cell2mat(nodes_data((str2double(node1)+1),2)))));
            disp(strcat(first_rooms(1,:),':',num2str(first_list(1))));
            disp(strcat(first_rooms(2,:),':',num2str(first_list(2))));
            disp(strcat(first_rooms(3,:),':',num2str(first_list(3))));
            disp('-----------------------');
        elseif i==2
            second_list = temp_list;
            second_rooms = temp_rooms;
            disp(strcat('node:',node2,':', num2str(cell2mat(nodes_data((str2double(node2)+1),2)))));
            disp(strcat(second_rooms(1,:),':',num2str(second_list(1))));
            disp(strcat(second_rooms(2,:),':',num2str(second_list(2))));
            disp(strcat(second_rooms(3,:),':',num2str(second_list(3))));
            disp('-----------------------');
            node3 = mat2str(cell2mat(data(count,1)));
            
        else
            third_list = temp_list;
            third_rooms = temp_rooms;
            disp(strcat('node:',node3,':', num2str(cell2mat(nodes_data((str2double(node3)+1),2)))));
            disp(strcat(third_rooms(1,:),':',num2str(third_list(1))));
            disp(strcat(third_rooms(2,:),':',num2str(third_list(2))));
            disp(strcat(third_rooms(3,:),':',num2str(third_list(3))));
            disp('-----------------------');
            
        end
        count = count +1;
    end
    
    
    
end