function dist = distest(par, x)

y = x(2,:);
x = x(1,:);
ypred = polyval(par,x,4);




dist = abs(ypred-y);

