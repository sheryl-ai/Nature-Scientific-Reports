function [y,y_omega,first,last] = comp_sub(y,y_omega)
%fill missing entries
    if sum(y_omega) ==0
        first=0;
        last=0;
        return
    end
    n = length(y);
    flag = 0;
    for i_order = 1:n % last occurrence carry forward strategy
        if y_omega(i_order) == 0 && flag == 0
            continue
        end        
        if y_omega(i_order) && flag == 0 
            flag = 1;first = y(i_order);
        end        
        if y_omega(i_order) == 0 && flag 
            y(i_order) = y(i_order-1);
            y_omega(i_order) = 1;
        end
    end      
    last = y(n);    
    for i_order =  n:-1:1      % first occurrence carry backward strategy
        if y_omega(i_order) == 0  
            y(i_order) = y(i_order+1);
            y_omega(i_order) = 1;
        end
    end
end