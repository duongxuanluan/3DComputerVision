function demo_1_ransac_estimation_of_mean
%% demo ransac: line fitting
clear variables
close all
rng(1)

%% generate the fictitious data 
n = (1:20)';                % set of sample indices; dataset size is 20
p = 1;                      % mean value of each data sample
S = 0.05;                   % standard deviation

% the linear model
y = p + S*randn(size(n));   % generate the data

%  for demonstration, generate the outliers
y(1:9) = y(1:9) - 1;        % 9 outliers
y = y(randperm(20));        % randomnize the order

% and plot
f=figure('units','normalized','outerposition',[0.1 0.1 0.8 0.8]);
stem(y,'r.','markersize',18); 
hold on; 
xlabel('sample index','FontSize',16)
ylabel('observed data','FontSize',16)

%% naive estimation
[pest, inliers] = iterative_mean(y);
hold on;
plot(n,pest+0*n,'linewidth',2);
plot(n(inliers),y(inliers),'b.','markersize',24);

%% ransac
[pest, inliers, ntrial] = ...
        ut_ransac(y', @estimator, 3, @absdiff, 4*S, @consistency, 0.55);
plot(n(inliers),pest+0*n(inliers),'k','linewidth',2);
plot(n(inliers),y(inliers),'ko','markersize',16);

% find the outliers
[y_out,outliers] = setdiff(y,y(inliers));
n = n(outliers);
plot(outliers,y_out,'g+','markersize',10);

% add legend
h=legend('data samples','naive mean','naive inliers','ransac mean','ransac inliers','ransac outliers');
h.Position = [0.8 0.5 0.1 0.15];  % move the legend
title('RANSAC DEMO: 20 data samples of which 9 are outliers')




 
%% naive estimation of the mean
function [pest, n] = iterative_mean(y)          % naive estimation
tol = 0.50;
n = 1:length(y);                                % generate the sample subscripts

pest = mean(y);                                 % first estimate of mean
while true
    Noutliers = sum(abs(pest-y)>=tol);          % number of outliers found
    if Noutliers==0, break; end                 % if no outliers are found anymore: exit
    index = find(abs(pest-y)<tol);              % find the samples that are inliers
    y = y(index);                               % select those samples
    n = n(index);                               % and the corresponding sample subscript
    pest = mean(y);                             % re-estimate mean
end
return

%% function to estimate the parameter from the data
function [pest, not_ok] = estimator(y)          
pest = mean(y);
not_ok = false;    % flag to see whether the estimation was successful                      

%% function to find the error for each sample
function dist = absdiff(pest,y)                 % error criterion is: absolute error
dist = abs(pest-y);
return

%% check to see whether the consensus set is ok
function ok = consistency(pest,y,Ndata)         
nmin = 0.5*Ndata;                               % size should of consensus set should at least has
ok = (length(y)>=nmin);                         %            a size larger than 50% of the data set                   
return

