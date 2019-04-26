function rate = progression_rate(time,score)

score = bsxfun(@minus,score,score(1,:));
score_abs = abs(score);
[~,idx] = max(score_abs,[],1);
[n,m]=size(score);
rate = zeros(1,m);
for j = 1:m
    idx(j) = n;
    i = idx(j);
    if i == 1
        continue
    end
    year = fix([time(1) time(i)]/100);
    month = [time(1) time(i)] - year * 100;
 
    year_diff = year(2) - year(1);
    month_diff = month(2) - month(1);
    time_diff = max(year_diff * 12 + month_diff,1);
    rate(j) = score(i,j)/time_diff;
end

end