function [tag_big,tag_small] = tag_each_cluster(idx,X,tag_num,feature_name)
% Hypothesis Testing: whether some feature are large only in one group?
[n,d] = size(X);
uni = unique(idx);
k = length(uni);
%% kruskal wallis test: whether the middle values of one feature are the same in different groups?
p_krusal = ones(1,d);
for j = 1:d
    p_krusal(j) = kruskalwallis(X(:,j),idx,'off');
end
%% multiple one vs one test: prove "1 > (2 and 3)" by "1>2 and 1>3"
p_pair_big = ones(k,k-1,d);
idx_tmp = 1:k;
for j = 1:d
    x = X(:,j);
    pj = ones(k,k-1);
    for r = 1:k
        idx_left = find(idx_tmp ~= r);
        x_main = x(idx == r);
        p = ones(1,k-1);
        for rr = 1:k-1
           y = x(idx == idx_left(rr));
           p(rr) = ranksum(x_main,y,'tail','right');
        end        
        pj(r,:) = p;
    end
    p_pair_big(:,:,j) = pj;
end
p_pair_small = 1 - p_pair_big;
%% Bonferroni correction is performed across multiple variables
p_pair_big = p_pair_big* d  ;
p_pair_small = p_pair_small   * d;
p_krusal = p_krusal * d;
%% if kruskal wallis test is passed, output the maximum p value across multiple one vs one test
p_mat_big = ones(k,d);
for j = 1:d
    if p_krusal(j) > 0.05
        continue
    end
    p_mat_big(:,j) = max(p_pair_big(:,:,j),[],2);
end
p_mat_small = ones(k,d);
for j = 1:d
    if p_krusal(j) > 0.05
        continue
    end
    p_mat_small(:,j) = max(p_pair_small(:,:,j),[],2);
end
%% output the features that have the smallest p values
[p_mat_big,idx_big] = sort(p_mat_big,2);
[p_mat_small,idx_small] = sort(p_mat_small,2);
tag_big = {};
tag_big{1}.pvalue =[];
tag_big{1}.tag =[];
for r = 1:k
    valid_num = sum(p_mat_big(r,:)<0.05); 
    valid_num = min(valid_num,tag_num);
    if valid_num < 1
        continue
    end
    p = p_mat_big(r,1:valid_num);
    t = idx_big(r,1:valid_num);
    tag_big{r}.pvalue = p;
    tag_big{r}.tag = t;
    tag_big{r}.value = mean(X(idx == r, t),1);
    tag_big{r}.name = feature_name(t);
end
tag_small = {};
tag_small{1}.pvalue =[];
tag_small{1}.tag =[];
for r = 1:k
    valid_num = sum(p_mat_small(r,:)<0.05);
    valid_num = min(valid_num,tag_num);
    if valid_num < 1
        continue
    end
    p = p_mat_small(r,1:valid_num);
    t = idx_small(r,1:valid_num);
    tag_small{r}.pvalue = p;
    tag_small{r}.tag = t;
    tag_small{r}.value = mean(X(idx == r, t),1);
    tag_small{r}.name = feature_name(t);
end

end