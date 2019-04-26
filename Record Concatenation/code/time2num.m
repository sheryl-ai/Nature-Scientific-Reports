function [ timenum ] = time2num( timestr )
%time to numbers
%%
totalnum=length(timestr);
for n=1:totalnum
    if sum(isnan(timestr{n}))==0
       timestr{n}=str2num(timestr{n}([4:7,1,2]));
    else 
       timestr{n}=0;
    end
end
%%
timenum=cell2mat(timestr);
end

