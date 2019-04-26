function [U,c,sigma] = KLtran(data)

    D = size(data,2);
    N = size(data,1);
    m = mean(data);
    data = bsxfun(@minus,data , m);
    S = data'*data/N;
    [U,sigma] = eig(S);
    sigma = diag(sigma);
    [C,I] = sort(sigma,'descend');    
    U = U(:,I);
    c = data * U;
    sigma = C;


end