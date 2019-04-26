function X = norm_gauss(X,Omega)

[n,d] = size(X);

for j = 1:d
   x = X(:,j);
   omega = Omega(:,j);   
   xx = x(omega>0);   
   uni = unique(xx);
   if length(uni) == 1
       x = ones(n,1);
   elseif length(uni) > 2
       m_xx = mean(xx);
       std_xx = std(xx);
       x = x - m_xx;
       x(omega==0) = 0;
       x = x/std_xx;
   end   
   X(:,j) = x;
end

end