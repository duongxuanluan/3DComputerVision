function e = err_eval(parm,X)
% Input:
% Parameters (4x1 column vector) and X(Nx4 column data set)
% Output:
% error criterion using Euclidian norm
global R D 
ym=X(:,1:2)';% 2xM row vectors
zm=X(:,3:4)';% 2xM row vectors
e1=(1/R)*vecnorm(ym-parm(1:2)); % error 1 of all the point - row vector
e2=(1/D)*vecnorm(zm-ym); % error 2 of all the point - row vector
e=sqrt(e1.^2+e2.^2); % Euclidian norm for row vector 
end
