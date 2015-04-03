function [ orientation ] = orientation( X1,Y1,X2,Y2)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    X_rel = X1-X2;
    Y_rel = Y1-Y2;
    
    if X_rel ==0 && Y_rel>0
        orientation ='S';        
    elseif X_rel ==0 && Y_rel<0
        orientation = 'N';
    elseif X_rel>0 && Y_rel==0
        orientation = 'W';
    elseif X_rel <0 && Y_rel==0
        orientation = 'E';    
    elseif X_rel >0 && Y_rel>0
        orientation ='SW';      
    elseif X_rel <0 && Y_rel<0
        orientation = 'NE';
    elseif X_rel>0 && Y_rel<0
        orientation = 'NW';
    else 
        orientation = 'SE';
    end

end

