function [err] = grad_exp_simple( Y,mu,w_pos,w_neg,type) 
if type == 1 || type == 3
    err =   Y - mu;
elseif type == 2 
    err = Y - mu;
    idx_pos = double(Y==1);
    idx_neg = double(Y==0);
    err_pos = bsxfun(@times,err,w_pos) .* idx_pos;
    err_neg = bsxfun(@times,err,w_neg) .* idx_neg;    
    err = err_pos+err_neg; 
end
end