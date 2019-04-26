function time = timeTran(time)
 
    year = fix(time/100);
    month = time - year * 100;
 
    year_diff = year  - year(1);
    month_diff = month  - month(1);
    time  =  year_diff * 12 + month_diff ;


end