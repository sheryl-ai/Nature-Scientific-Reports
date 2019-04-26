function mu = link_fun_mu_simple(g,type)
if type == 1 
    mu = g;  
elseif type == 2   
    mu =  1./(1+exp(-g));
elseif type == 3   
    mu = exp(g);    
end
end