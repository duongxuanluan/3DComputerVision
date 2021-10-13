%% generate data for testing ransac.m

N=50;      % number of samples
w=0.4;      % probability that a sample is an outlier
a = 1;
x = rand(N,1)*2-1;
y = 1 -5*x.^2 + 5*x.^4;

ind = randsample(N,round(0.5*w*N));    
y(ind) = -2 + 3*x(ind).^2 + 0.05*randn(size(x(ind)));
ind = randsample(N,round(0.5*w*N));    
y(ind) = polyval([4 0.9 -3.7 -0.6 0.6],x(ind));    

ut_figure(1,14,20);
subplot(3,1,1);
plot(x,y,'r.','markersize',12);
xlabel('x');
ylabel('y')
title('dataset')

h=subplot(3,1,2);
plot(x,y,'r.','markersize',12);
xlabel('x');
ylabel('y')

subplot(3,1,3);
plot(x,y,'r.','markersize',12);
xlabel('x');
ylabel('y')


