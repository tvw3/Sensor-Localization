function [ result ] = compress( candi, prob )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    [can_row can_col] = size(candi);
    temp = candi(:,1);
    result = cat(2,temp,candi);
    unknown= {};
    unknown{end+1}= result{1,1};
    for a=1:can_row
        if isempty(result{a,4})
           result{a,4} = 0;
           str = result{a,1};
           if ~ismember(unknown(1,:),str)
               unknown{end+1}=str;
           end
        else
            result{a,1}=str;
        end
    end
    unknown;

    temp = setdiff(unique(temp),result(:,1));
    prob_table = cell(length(temp),2*length(unknown));
    [prob_row prob_col] =size(prob_table);
    index=1;
    end_index = unknown;
    for a = 1:length(end_index)
        if a == length(end_index)
            end_index(1,a)=mat2cell(length(prob)+1,1);
        else
            end_index(1,a) = mat2cell(find(ismember(prob(:,1),end_index(1,a+1))),1);
        end
    end
    
    

           position=1;
    for a=1:2:prob_col
        start= find(ismember(prob(:,1),unknown(1,position)))+1;
        finish = end_index{1,position}-1;
        index=1;
        position=position+1;
        for b=start:finish
                prob_table{index,a} = prob{b,1};
                prob_table{index,a+1} = prob{b,2};
                index=index+1;
                         
        end
    end
    
    for a=1:2:prob_col
        for b = 1:prob_row
        if isempty(prob_table{b,a})
            prob_table{b,a}='';
            prob_table{b,a+1}= 0;
        end
        end
    end
    for a=1:2:mod(prob_col,length(unknown))
        
        
        set = intersect(prob_table(:,a),prob_table(:,a+2));
        if ~isempty(set)
                index= find(ismember(prob_table(:,a),set{2,1}),1);
                prob_table{index,a+1}=0;
        end
    end

   temp = cell(1,prob_col);
   for a =1:length(unknown)
       temp{1,a*2} = unknown{1,a};
%        temp{1,a+1}= 'Conditioned On';
   end
    
    result =cat(1,temp,prob_table);
    
end

