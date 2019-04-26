function W = MTL_STL(X,Y,lambda)
%squared loss
D = size(X,2);
W = ( X'*X+lambda *eye(D))\X'* Y;  
end