clear variable
close all

% generate 100 2D samples 30% from one distribution, and 70% from another
% distribution:
generate_data;
T=0.15;
n= 4;
xplot = linspace(-1,1,201);

%% naive estimation
% estimate the parameters
subplot(3,1,2)
hold on
colorsp = {'bo','gx','k+','mo','yo','bo','go','ko','mo','yo'};
colorsl = {'b','g','k','m','y','b','g','k','m','y'};
xtest = x;
ytest = y;

for i=1:3                                                  % iterate a number of times
    
    

    p = polyfit(xtest,ytest,n);
    yplot = polyval(p,xplot);
    plot(xplot,yplot,colorsl{i});
    ypredicted = polyval(p,x);
    dis = abs(y-ypredicted);
                                                            % calculate distance to model
    ind = find(dis<T);                                      % find indices of inliers
    xtest = x(ind);
    ytest = y(ind); % remove outliers
    plot(xtest,ytest,colorsp{i});                      % plot
    title(['naive estimation  #inliers: ' num2str(length(ind))])
end
chH = get(gca,'Children');
set(h,'Children',chH(fliplr([6 4 2 1 3 5 7])))
legend('1st iter','2nd iter','3rd iter','location','southeast')


%% ransac
subplot(3,1,3)
Xset = [x y];
[p, inliers, ntrial] = ut_ransac(Xset', @est_mu, 5, @distest, T, @consistencycheck, 0.3);
% est_mu:       function that estimates the mean vector and the covariance matrix
% distest:      function that find the distances of samples to the find distribution
% consistencycheck: function that checks whether the solution is consistent
%                   that is, whether the inliers support the assumption
%                   that they are from one distribution

hold on
% ind_false_accepted = intersect(ind2,inliers');
% ind_missed = setdiff(ind1,inliers');
% plot(x(1,ind_missed),x(2,ind_missed),'gx');
% plot(x(1,ind_false_accepted),x(2,ind_false_accepted),'kx');
% ind_trueneg = setdiff([ind1' ind2],inliers');

plot(x(inliers),y(inliers),'bo');
    yplot = polyval(p,xplot);
    plot(xplot,yplot,colorsl{1});



title(['ransac estimation #inliers: ' num2str(length(inliers))])

disp(['number of trials: ' num2str(ntrial)])
% print -r600 -dpng ransac_est.png