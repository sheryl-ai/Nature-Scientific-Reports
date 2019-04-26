function [y,y_omega,first,last] = comp_sub_age(y,y_omega,time,avg_age_start)
%fill missing entries for age 
    if sum(y_omega) ==0
         y(2) = avg_age_start;
         y_omega(2) = 1;
%          first=0;
%          last=0;
%          return
    end    
    n = length(y);
    bias_year = 0;
    bias_age = 0;   
    flag = 0;
    for i_order = 1:n % last occurrence carry forward strategy
        if y_omega(i_order) == 0 && flag == 0
            continue
        end        
        if y_omega(i_order) && flag == 0
            flag = 1;
            bias_year = fix(time(i_order)/100);
            bias_age = y(i_order);
            first = y(i_order);
        end        
        if y_omega(i_order) == 0 && flag 
            y(i_order) = (fix(time(i_order)/100) - bias_year) + bias_age;            
            y_omega(i_order) = 1;
        end
    end    
    last = y(n);    
    for i_order =  n:-1:1      %  first occurrence carry backward strategy
        if y_omega(i_order) == 0  
            y(i_order) = (fix(time(i_order)/100) - bias_year) + bias_age;
            y_omega(i_order) = 1;
        end
    end

end