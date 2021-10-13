function [parm_est, not_ok] = est_parm(Xsub)
% Input:
% Xsub 1st and 2nd row is x,y location of points in pic 1
% Xsub 3rd and 4th row is x,y location of points in pic 2
% Output: 
% Location center of the cloud in pic 1 and pic 2 (4x1 - colume vector)
% not ok: checking if the calculation is possible
parm_est = mean(Xsub')';
not_ok = 0;    % flag to see whether the estimation was successful    