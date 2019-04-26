function model = MTL_STL_binary(X,Y,C)
%logistic loss
m = size(Y,2);
D = size(X,2); 
Y(Y==0)=-1;
model = {};
for i = 1:m
   y = Y(:,i);
   n_pos = sum(y==1);
   n_neg = sum(y==-1);
   n = n_pos + n_neg;
   model{i} = linearsvmtrain(y,sparse(X),sprintf('-s 0 -c %f  -q   -w1 %f -w-1 %f' ,C,n/(2*n_pos),n/(2*n_neg)));
end

end