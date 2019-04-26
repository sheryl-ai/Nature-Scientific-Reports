function model = multi_label_exp(X,Y,task_type,para)

model = {};
for type = 1:2
   idx = task_type == type;
   if sum(idx)==0
       continue
   end
   y = Y(:,idx);
   if type == 1
       model{type} = MTL_STL(X,y,para(1));
   elseif type == 2
       model{type} = MTL_STL_binary(X,y,para(2));
   end
end

end