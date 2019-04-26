function Mu = multi_label_exp_predict(X,Y,model,task_type)

n = size(X,1);
m = length(task_type);
Mu = zeros(n,m);
for type = 1:2
   idx = task_type == type;
   if sum(idx)==0
       continue
   end
   if type == 1
       Mu(:,idx) = X*model{type};
   elseif type == 2
       mu = zeros(n,sum(idx));
       y_true = Y(:,idx);
       y_true(y_true==0)=-1;
       for j = 1:sum(idx)
            
           [label_out,acc,prob] =  linearsvmpredict(y_true(:,j),sparse(X),model{type}{j},'-b 1');
           
           mu(:,j) = prob(:,1);           
       end
       Mu(:,idx) = mu;
   end
end

end