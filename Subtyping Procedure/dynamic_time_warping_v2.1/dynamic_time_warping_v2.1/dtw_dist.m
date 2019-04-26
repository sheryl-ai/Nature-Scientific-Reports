function d = dtw_dist(data,dim) 

 

if dim == 3
   
    [n_time,n_channel,n_sample] = size(data);
    w = 50;
    d = zeros(n_sample);
    parfor i = 1:n_sample
        disp(i)
        for j = 1:n_sample
            
            x = data(:,:,i);
            y = data(:,:,j);
            
            d(i,j) = dtw_c(x,y,w);
            
        end
    end
    
    
end


end