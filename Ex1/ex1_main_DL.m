%%%%% 3DCV Exercise 1: VIRTUAL ROTATION OF THE CAMERA %%%%%%%%%%%%%

%% Summary 
% Calibration the measurement of foot images using:
% - image of foot given
% - Chessboard for camera calbiration 
% - Matlab fnc ut_plot_lens_distortion for visualization of the image 
clear all; close all

%% Part 1: Camera calibration 
% 1.1 Using camera calibration app in Matlab to select chessboard images
% The size of chessboard is 40mm
% save cameraParams cameraParams
load cameraParams;

% 1.2 Image size: 1944x2592, visualize image
imsize=[1944,2592];
ut_plot_lens_distortion(cameraParams,imsize);

%% Part 2: Nonlinear lens distortion 
% 2.1 Calculate corners without distortion
% imshow(imread('voet.jpg'));
% roi=drawpolygon;
% p=roi.Position;
% save p p
p=[7.562119377104335e+02,1.176222905623030e+03;...
    1.059961465736607e+03,2.910014809128537e+02;...
    1.704208250594654e+03,3.858322927626756e+02;...
    1.424121676781341e+03,1.380464510787172e+03];
Pcomp=undistortPoints(p,cameraParams);
corner_shift=vecnorm((Pcomp-p)');

% 2.2 Un-distort image
non_lensdistort_image=undistortImage(imread('voet.jpg'),cameraParams);
imshow(non_lensdistort_image);

%% Part 3: Perspective distortion
%3.1 Find angles 2 and 3
side_12=Pcomp(1,:)-Pcomp(2,:);
side_23=Pcomp(3,:)-Pcomp(2,:);
corner2=rad2deg(acos(dot(side_12,side_23)/(norm(side_12)*norm(side_23))));
side_23=Pcomp(2,:)-Pcomp(3,:);
side_34=Pcomp(4,:)-Pcomp(3,:);
corner3=rad2deg(acos(dot(side_23,side_34)/(norm(side_23)*norm(side_34))));

%3.2 Measure the side
%imtool(non_lensdistort_image);
%messide=[messide_12; messide_23; messide_34; messide_41];
%save messide messide
messide=[9.401886806832057e+02;6.513452812406317e+02;...
    1.032725758671771e+03;7.029338211827289e+02];
ratio=min(messide)/max(messide);

%% Part 4: Camera rotation for perspective distortion
% 4.1 Roll angle is no needed
% 4.2 I use the distance/ but   
% 4.3 Check the error_measure fnc 

%% Part 5: Finding the rotation
%5.1 Finding the rotation
options = optimset('Display','iter','MaxFunEvals',10000,'MaxIter',5000); % set options
EAstart = [0;0]; % start values
foo = @(Eangles)error_measure(Eangles,cameraParams.IntrinsicMatrix,Pcomp); % create anonymous function
[EA,J] = fminsearch(foo,EAstart,options); % minimize the error measure
EAdeg=rad2deg(EA);

%% Part 6: Application to the image
% 6.1 Find the homography 
R=eul2rotm([0 EA']); % Create matrix R
K=cameraParams.IntrinsicMatrix;
H=K'*R*inv(K'); % Making homography 

% 6.2 Apply to the image
Tform = projective2d(H'); % Note: Matlab uses the transposed form
[im_sim,Rout]=imwarp(non_lensdistort_image,Tform,'FillValues',[255;255;255]); 
figure;
imagesc(Rout.XWorldLimits,Rout.YWorldLimits,im_sim);
xlabel('u');
ylabel('v');

%% Part 7: Confirm result
%7.1 updated corner
% imagesc(Rout.XWorldLimits,Rout.YWorldLimits,im_sim);
% roi2=drawpolygon;
% save roiend
% p2=roi2.Position;
% save p2 p2
p2=[2.108920036345631e+02,6.365089086397159e+02;...
    5.304167586193732e+02,-4.212958798804067e+02;...
    1.281399373780810e+03,-1.960527706115322e+02;...
    9.622611229784709e+02,8.616031439317375e+02];
side_12=p2(1,:)-p2(2,:);
side_23=p2(3,:)-p2(2,:);
corner2=rad2deg(acos(dot(side_12,side_23)/(norm(side_12)*norm(side_23))));
side_23=p2(2,:)-p2(3,:);
side_34=p2(4,:)-p2(3,:);
corner3=rad2deg(acos(dot(side_23,side_34)/(norm(side_23)*norm(side_34))));
% 7.2 update sides
side_12=norm(side_12);
side_23=norm(side_23);
side_34=norm(side_34);
side_41=p2(1,:)-p2(4,:);
side_41=norm(side_41);
side=[side_12 side_23 side_34 side_41];
% 7.3 update ratio
ratio2=min(side)/max(side);
% 7.4 uncertainty 
% Using scaling for sides 
mean_long_side=(side_12+side_34)/2;
unct_long_side=abs(side_12-mean_long_side)/mean_long_side*297;
mean_short_side=(side_23+side_41)/2;
unct_short_side=abs(side_23-mean_short_side)/(mean_short_side)*210;
unct_angle1=abs(sin(deg2rad(corner2-90)))*297*2/3;
unct_angle2=abs(sin(deg2rad(corner3-90)))*297*2/3;
unct=norm([unct_long_side unct_short_side unct_angle1 unct_angle2]); % least square 