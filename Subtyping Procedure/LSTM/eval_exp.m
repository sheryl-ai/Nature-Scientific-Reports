function [nmse,auc,nmse_poiss,score_vec] = eval_exp(Y,Mu,task_type)
 
nmse = 100;
auc = -1;
nmse_poiss = 100;

[n,m] = size(Y);
score_vec = zeros(1,m);

  
for label_type = 1:3
    idx = task_type  == label_type;
    if sum(idx) == 0
        continue
    end
    mu = Mu(:,idx);
    y_true = Y(:,idx);    
    if label_type == 1
        y_pred = mu;
        mse = [];
        for i = 1:size(y_true,2)
            mse_i =  sum(((y_pred(:,i) - y_true(:,i)).^2),1)  ./(n * (var(y_true(:,i))+eps));
            mse = [mse  mse_i];
        end
        score_vec(idx) = mse;
        nmse = mean(mse);
    elseif label_type == 2
        y_pred = mu;
        auc = [];
        for i = 1:size(y_true,2)
            if length(unique(y_true(:,i)))<=1
                auc_i = 0.5;
            else
            [~,~,~,auc_i] = perfcurve(y_true(:,i),y_pred(:,i),1);  
            end
            auc = [auc  auc_i];
        end
        score_vec(idx) = auc;
        auc = mean(auc);
    else
        y_pred = mu;
        mse = [];
        for i = 1:size(y_true,2)
            mse_i =  sum(((log(y_pred(:,i)+1) -log( y_true(:,i) + 1)).^2),1)  ./(n * (var(log(y_true(:,i)+1))+eps));
            mse = [mse mse_i];
        end
        score_vec(idx) = mse;
        nmse_poiss = mean(mse);
    end
end

end