function [par, not_ok] = est_mu(x)

y = x(2,:);
x = x(1,:);

par = polyfit(x,y,4);
not_ok = (length(x)<5);