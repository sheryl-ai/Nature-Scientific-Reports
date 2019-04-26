% Copyright (C) 2013 Quan Wang <wangq10@rpi.edu>,
% Signal Analysis and Machine Perception Laboratory,
% Department of Electrical, Computer, and Systems Engineering,
% Rensselaer Polytechnic Institute, Troy, NY 12180, USA

% this is a demo showing the use of our dynamic time warping package 
% we provide both Matlab version and C/MEX version
% the C/MEX version is much faster and highly recommended

clear;clc;close all;


%mex dtw_c.c;
% 
% a=rand(500,1);
% b=rand(520,1);

x =[ 0:0.01:5]';
a=sin(x);
b=cos(5*x );

figure
subplot(2,1,1)
plot(a)
subplot(2,1,2)
plot(b)

w=10;

tic;
d1=dtw(a,b,w);
t1=toc;

tic;
d2=dtw_c(a,b,w);
t2=toc;

fprintf('Using Matlab version: distance=%f, running time=%f\n',d1,t1);
fprintf('Using C/MEX version: distance=%f, running time=%f\n',d2,t2);

record = [];
for w = 1:max(length(a),length(b))
    d=dtw_c(a,b,w);
    record = [record;[w d]];
end

figure
plot(record(:,1),record(:,2))



%a,b : ����Խ��Խ��
%