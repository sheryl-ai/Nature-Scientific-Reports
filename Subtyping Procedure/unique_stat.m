function [uni_x,num,p] = unique_stat(x)

uni_x = unique(x);
n_uni = length(uni_x);
p = zeros(n_uni,1);
for i_uni = 1:n_uni
    p(i_uni) = sum(x == uni_x(i_uni));
end
num = p;
p = p/sum(p);

end