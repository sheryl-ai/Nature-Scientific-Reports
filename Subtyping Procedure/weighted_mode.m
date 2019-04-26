function v = weighted_mode(A,W)

N = size(A,1);
D = size(A,2);
v = zeros(N,1);
for i = 1:N
    w = W(i,:);
    A_i = A(i,:);
    option = union(A_i,[]);
    num = length(option);
    score = zeros(num,1);
    for j = 1:num
        score(j) = w * (A_i == option(j))';
    end
    [C,I] = max(score);
    v(i) = option(I);
end

end