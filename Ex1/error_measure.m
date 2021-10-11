function J = error_measure(Eangles, K, Pcomp)
% ERROR_MEASURE calculates the error measure that quantifies the
% deviation from a similarity transform using the corners of the A4
%
% Eangles: two Euler angles stored in an array
% K: calibration matrix
% Pcomp: coordinates of the four corner points
% J: error measure after applying the virtual rotation

% Step A: Calculate homography from Euler angles
R=eul2rotm([0 Eangles']); % Create matrix R
H=K'*R*inv(K'); % Making homography 

% Step B: Calculate the new corner with homography 
Pcomph=cart2hom(Pcomp); % change into homogeneous coordinate
Pcomp_persp_undistort = H*Pcomph'; % Undistort perspective
Pcomp_persp_undistort = hom2cart(Pcomp_persp_undistort'); % change back cart

% Step C: Calculate the errors - we used the equal lengths properties 
side_12=norm(Pcomp_persp_undistort(1,:)-Pcomp_persp_undistort(2,:));
side_23=norm(Pcomp_persp_undistort(2,:)-Pcomp_persp_undistort(3,:));
side_34=norm(Pcomp_persp_undistort(3,:)-Pcomp_persp_undistort(4,:));
side_41=norm(Pcomp_persp_undistort(4,:)-Pcomp_persp_undistort(1,:));
J=norm([side_41-side_23,side_34-side_12]); % least square 

% % Step C: Calculate the errors - we used the ratio properties 
% side_12=norm(Pcomp_persp_undistort(1,:)-Pcomp_persp_undistort(2,:));
% side_23=norm(Pcomp_persp_undistort(2,:)-Pcomp_persp_undistort(3,:));
% side_34=norm(Pcomp_persp_undistort(3,:)-Pcomp_persp_undistort(4,:));
% side_41=norm(Pcomp_persp_undistort(4,:)-Pcomp_persp_undistort(1,:));
% A4=210/297;
% side=[side_12 side_23 side_34 side_41]
% J= abs(min(side)/max(side)-A4)






