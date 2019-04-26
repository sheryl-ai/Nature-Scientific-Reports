function [l] = link_fun_simple(y,g,w_pos,w_neg,type)
m = size(y,2);
if type == 1   
    a =  eye(m) ;
    b = g.^2/2;
    c = bsxfun(@plus,-y.^2/2,log(diag(a)')) - log(2*pi)/2;
    l = (y.*g - b) + c;
elseif type == 2
    b = g + log(1+exp(-g));
    if any(isinf(b))
        b = g + max(0,1-g);
    end
    l = (y.*g - b);
    
    idx_pos = double(y==1);
    idx_neg = double(y==0);
    l_pos = bsxfun(@times,l,w_pos) .* idx_pos;
    l_neg = bsxfun(@times,l,w_neg) .* idx_neg;    
    l = l_pos+l_neg; 
    
elseif type == 3
    b = exp(g);   
    l = (y.*g - b) - gammaln(y+1) ;
end
end