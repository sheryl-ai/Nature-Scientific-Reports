function [num,fm] = feedback_fun(fm,i,idx_control)

        N = sum(~idx_control);
        b = 2/(N-1);a = 1+b; %smooth factor


        dlambda = gamrnd(fm{i}.alpha+a,fm{i}.beta+b);
        fm{i}.lambda_poisson = (1-fm{i}.poisson_rate) * fm{i}.lambda_poisson + fm{i}.poisson_rate * dlambda;
        
        num = poissrnd(fm{i}.lambda_poisson); 
        num = max(1,num);
        num = min(sum(~idx_control),num);


end