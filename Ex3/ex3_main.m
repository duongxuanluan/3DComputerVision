%%%%% 3DCV Exercise 3: Key points detection and matching %%%%%%%%%%%%%

%% Summary 
% Keypoint: Isolated points that locatable and indentifable
% SIFT - Scale invariant feature transform => Identifying keypoints descriptors
% Keypoints has scale + orientation property: k-fold rotation symmetry
% Trial and error process for keypoints finding method
% Purpose of exercise : Given sequence of bending knee
% a/ What are keypoints b/ which matching method c/ robust estimation
% algorithm for tracking leg ?
% Idea: robust alg finding keypoints of upper leg => Match to key points
% belong to lower leg

% Available data
% - 7 Images hand held camera of bending leg 
% - RANSAC for robustness
% - Visualization file ut_plotcov3 and ut_plot_axis3D

clear all; close all

%% Part 1: Data Preparation
% Color preprocessing - rgb to grey image with optimize conversion
% (suppress red color)
% I=aR+bG+cB+d with optimized a,b,c,d using PCA
% 1.1: Read the images 
I1=imread('ACLtestL01.png');
I2=imread('ACLtestL02.png');
im1=im2double(I1); % change to double data
im2=im2double(I2);

% 1.2: To suppress red pattern, need to know the pixels RGB values of the
% red pattern. This part we choose ROI of this red pattern (no marker)
load 'imroi.mat'
%figure; imshow(im1); % show im1 in a figure window
%[imroi,rect] = imcrop; % select a rectangular roi in the image
                        % that only contains the red pattern on
                        % the leg
%[nr,nc,~] = size(imroi); % get the size of the roi
%imroi = reshape(imroi,nc*nr,3); % reshape to a (nc*nr) x 3 array
figure(1); % visualize as a cloud in the RGB space
plot3(imroi(:,1),imroi(:,2),imroi(:,3),'.','Markersize',1);
daspect([1 1 1]); % equalize the scales of the axes
xlabel('red');
ylabel('green');
zlabel('blue');
box on
%save imroi imroi

% 1.3: Measuring directivity (covariance) of obtained cloud in RGB space
% and center of gravity (mean) of data set
Covmat_roi = cov(imroi); % estimate covariance matrix
mean_roi = mean(imroi); % estimate the mean
surfp.specularstrength = 1; % the strength of glossy reflection
surfp.diffusestrength = 0.5; % the strength of matt reflection
surfp.ambientstrength = 0.7; % the strength of ambient illumination
surfp.specularexponent = 25; % the size of glossy spots
surfp.facealpha = 0.3; % the transparency of a surface
hold on % plot ellipsoid representing scattering
ut_plotcov3([],50,50,mean_roi',Covmat_roi,[0.9 0.4 0],surfp);
camlight('left') % turn on some spot lights
camlight('right')
% Red is most elongated, green is most flat

% 1.4: The covariance matrix is an ellipse with 3 axis and 3 width as:
[E,L] = eig(Covmat_roi); % get eigenvectors and eigenvalues
T = [E mean_roi'; 0 0 0 1]; % create 4x4 transformation matrix
h = ut_plot_axis3D([],T,'arrowlength',0.15);
view(-50,60)

% 1.5: sort the eig in ascending level
[L,ind] = sort(diag(L)); % sort eigenvalues, small to large
E = E(:,ind); % sort corresponding eigenvalue

% 1.6: Projecting components on a direction with least red pattern (e(1))
[K,M,~] = size(im1); % get size of images
im1g = reshape(im1,K*M,3); % reshape image to vector style
im1g = im1g*E(:,1); % suppress the red pattern
                    % by projecting on the direction with
                    % minimum variation in the red pattern
                    
% 1.7: Fitting into an intensity image [0,1] by normalizing the image with
% mean 0 and std 1.
% normalize the grey level range
gmean = mean(im1g); % get the mean grey level
gstd = std(im1g); % get the standard deviation
im1g = (im1g-gmean)/gstd; % normalize mean and std dev
im1g = im1g/25 + 0.5; % adapt the range so that it fits [0,1];
im1g = reshape(im1g,K,M); % reshape back to image format


% 1.8: To not repeat step 1.2 to 1.5, we extract value a,b,c,d and use for
% other images
% get conversion parameters for other images
A = E(:,1)/(25*gstd); % the parameters a,b, and c
d = 0.5 - gmean/(25*gstd); % the parameter d

% 1.9: Transform all the images
% transform the images
 a = A(1);
 b = A(2);
 c = A(3);
 d= d;
im1g = a*im1(:,:,1) + b*im1(:,:,2) + c*im1(:,:,3) + d;
im2g = a*im2(:,:,1) + b*im2(:,:,2) + c*im2(:,:,3) + d;
figure(2)
imshow(im1g)
imwrite(im1g, '1.9-im1g.png')
figure(3)
imshow(im2g)
imwrite(im2g, '1.9-im2g.png')

%% Part 2: Key point detection and visualization 
% Keypoints: Corner-like features or blob-like feature
% Using computer vision toool box
% - Corner feature: HARRIS, MIN_EIGENVALUE, FAST, ORB
% - Blob feature: BRISK, SURF, MSER, KAZE
% Note: no SIFT keypoints bcz of patent
% Note2: Computer vision toolbox uses classes instead of structs, which has
% methods or object function
% PURPOSE: Apply all 8 feature detecors to im1g
P11=detectHarrisFeatures(im1g,'MinQuality',0.01,'ROI', [410,175,550,210]);
P12=detectMinEigenFeatures(im1g,'MinQuality',0.01,'FilterSize',5,'ROI', [410,175,550,210]);
P13=detectFASTFeatures(im1g,'MinContrast',0.01,'ROI', [410,175,550,210]);
P14=detectORBFeatures(im1g,'ScaleFactor',1.5,'NumLevels',15);
P15=detectBRISKFeatures(im1g,'MinContrast',0.01,'ROI', [410,175,550,210]); 
P16=detectSURFFeatures(im1g,'MetricThreshold',300,'ROI', [410,175,550,210]);
P17=detectKAZEFeatures(im1g,'Diffusion','edge','Threshold',0.0001,'ROI', [410,175,550,210]);
P18=detectMSERFeatures(im1g,'ThresholdDelta',0.7,'ROI', [410,175,550,210]);

% figure(4)
% imshow(im1g); hold on; plot(P11.selectStrongest(500)); title('Harris im1g')
% hold off
% figure(5)
% imshow(im1g); hold on; title('MinEigen im1g'); plot(P12.selectStrongest(500));
% hold off
% figure(6)
% imshow(im1g); hold on; title('FAST im1g'); plot(P13.selectStrongest(500));
% hold off
% figure(7)
% imshow(im1g); hold on; plot(P14.selectStrongest(500)); title('ORB im1g')
% hold off
% figure(8)
% imshow(im1g); hold on; plot(P15.selectStrongest(500)); title('BRISK im1g')
% hold off
% figure(9)
% imshow(im1g); hold on; plot(P16.selectStrongest(500)); title('SURF im1g')
% hold off
% figure(10)
% imshow(im1g); hold on; plot(P17.selectStrongest(500)); title('KAZE im1g')
% hold off
% figure(11)
% imshow(im1g); hold on; plot(P18);
% title('MSER im1g')
% hold off

%% Part 3: Key point detection and visualization for 2nd image 
P21=detectHarrisFeatures(im2g,'MinQuality',0.01,'ROI', [410,175,550,210]);
P22=detectMinEigenFeatures(im2g,'MinQuality',0.01,'FilterSize',5,'ROI', [410,175,550,210]);
P23=detectFASTFeatures(im2g,'MinContrast',0.01,'ROI', [410,175,550,210]);
P24=detectORBFeatures(im2g,'ScaleFactor',1.5,'NumLevels',15);
P25=detectBRISKFeatures(im2g,'MinContrast',0.01,'ROI', [410,175,550,210]); 
P26=detectSURFFeatures(im2g,'MetricThreshold',300,'ROI', [410,175,550,210]);
P27=detectKAZEFeatures(im2g,'Diffusion','edge','Threshold',0.0001,'ROI', [410,175,550,210]);
P28=detectMSERFeatures(im2g,'ThresholdDelta',0.7,'ROI', [410,175,550,210]);
% figure(12)
% imshow(im2g); hold on; plot(P21.selectStrongest(500)); title('Harris im2g')
% hold off
% figure(13)
% imshow(im2g); hold on; title('MinEigen im2g'); plot(P22.selectStrongest(500));
% hold off
% figure(14)
% imshow(im2g); hold on; title('FAST im2g'); plot(P23.selectStrongest(500));
% hold off
% figure(15)
% imshow(im2g); hold on; plot(P24.selectStrongest(500)); title('ORB im2g')
% hold off
% figure(16)
% imshow(im2g); hold on; plot(P25.selectStrongest(500)); title('BRISK im2g')
% hold off
% figure(17)
% imshow(im2g); hold on; plot(P26.selectStrongest(500)); title('SURF im2g')
% hold off
% figure(18)
% imshow(im2g); hold on; plot(P27.selectStrongest(500)); title('KAZE im2g')
% hold off
% figure(19)
% imshow(im2g); hold on; plot(P28);
% title('MSER im2g')
% hold off

% Choose keypoint detection method that is most suitatble: Min Eigen
P1=P12;
P2=P22;

%% Part 4: Keypoint matching and visualization
% Using different techniques of keymatching 
% BRISK
[D11,P11v] = extractFeatures(im1g,P17,'Method','BRISK');
[D21,P21v] = extractFeatures(im2g,P27,'Method','BRISK');
M1=matchFeatures(D11, D21, 'MaxRatio',1);
figure(20)
showMatchedFeatures(im1g,im2g,P11v(M1(:,1)), P21v(M1(:,2)),'montage');
% FREAK
[D12,P12v] = extractFeatures(im1g,P1,'Method','FREAK');
[D22,P22v] = extractFeatures(im2g,P2,'Method','FREAK');
M2=matchFeatures(D12, D22, 'MaxRatio',0.75);
figure(21)
showMatchedFeatures(im1g,im2g,P12v(M2(:,1)), P22v(M2(:,2)),'montage');
% SURF
[D13,P13v] = extractFeatures(im1g,P1,'Method','SURF');
[D23,P23v] = extractFeatures(im2g,P2,'Method','SURF');
M3=matchFeatures(D13, D23, 'MaxRatio',0.5);
figure(22)
showMatchedFeatures(im1g,im2g,P13v(M3(:,1)), P23v(M3(:,2)),'montage');
% ORB
[D14,P14v] = extractFeatures(im1g,P14,'Method','ORB');
[D24,P24v] = extractFeatures(im2g,P24,'Method','ORB');
M4=matchFeatures(D14, D24, 'MaxRatio',1);
figure(23)
showMatchedFeatures(im1g,im2g,P14v(M4(:,1)), P24v(M4(:,2)),'montage');
% KAZE
[D15,P15v] = extractFeatures(im1g,P1,'Method','KAZE');
[D25,P25v] = extractFeatures(im2g,P2,'Method','KAZE');
M5=matchFeatures(D15, D25, 'MaxRatio',0.6);
figure(25)
showMatchedFeatures(im1g,im2g,P15v(M5(:,1)), P25v(M5(:,2)),'montage');
% Block
[D16,P16v] = extractFeatures(im1g,P1,'Method','Block');
[D26,P26v] = extractFeatures(im2g,P2,'Method','Block');
M6=matchFeatures(D16, D26, 'MaxRatio',0.5);
figure(26)
showMatchedFeatures(im1g,im2g,P16v(M6(:,1)), P26v(M6(:,2)),'montage');

% Choosing the matching technique: Block
P1v=P16v(M6(:,1));
P2v=P26v(M6(:,2));

%% Part 5: Inlier detection and cluster identification
% Purpose: Robustness - no outliers, keypoints on upper and lower leg
% We use RANSAC - parametric model describing a dataset (without outliers)
% Input:
% - Data: M match keypoints from 2 images x=(x1,y1,x2,y2). Make data X
% (4xM) or with scales and orientation then 8xM
% - Model: Identifying the cluster apply Ransac twice for 2 clusters. 
%||y-p||<R where p is position of cluster that RANSAC estimate. R -designed
%||z-y||<D where z, y are 2 matching keypoints. D is tolerance - designed
% Displacement model include rotating and translation 3D rigid body ( using
% the 3D estimation from exercise 2). However, techniques becomes
% complicate
% - Estimator: to estimate parameter p - center of cluster. Using mean func
% - Error criterion: check if data belong to cluster or not
% Using model, e=1/R|y-p_hat|+ 1/D|z-y|. Can use diffeerent approaches
% M dimensional array
% - Detection of inliers: Threshold for error criterion. Set of inliner-
% consensus set Xcon
% - Consistency checking: 0 or 1. For ex- number of consensus large enough
% comparing with M? 
% flag= C(p_hat,Xcon, M)

% 5.1 Preparation
% 5.2 Choose the model: same as suggested
% 5.3 The estimator: Check function est_parm below 
% 5.4 The error criterion: Check function err_eval below
% 5.5 The consistency check: Check function consistencycheck below 

% 5.6 Apply to RANSAC
% Generate data X of matched  
X(:,1:2)=P1v.Location; % from image 1
X(:,3:4)=P2v.Location; % from image 2

% Set up constant
n=4; % The number of data vectors needed to estimate the parameters.
w= 0.55; %The assumed probability of an inlier. This parameter is
         %used to determine the maximum number of random
         %selections. This number is determined according to:
         %Nmax = round(3*w^-n);
global percentage R D
percentage=0.1; % size of consensus set should at least has (percentage of 
                % data set
tol=0.6; % tolerance for error function          
R=150;
D=100;     
[pest1, inliers_part1, ntrial1] = ...
        ut_ransac(X', @est_parm, n, @err_eval, tol, @consistencycheck,w);
figure(27)
showMatchedFeatures(im1g,im2g,X(inliers_part1,1:2), X(inliers_part1,3:4),'blend');
% Another part of the leg
X_new=X; 
X_new(inliers_part1,:)=[];
[pest2, inliers_part2, ntrial2] = ...
        ut_ransac(X_new', @est_parm, n, @err_eval, tol, @consistencycheck,w);
figure(28)
showMatchedFeatures(im1g,im2g,X_new(inliers_part2,1:2), X_new(inliers_part2,3:4),'blend');






function [parm_est, not_ok] = est_parm(Xsub)
% Input:
% Xsub 1st and 2nd row is x,y location of points in pic 1
% Xsub 3rd and 4th row is x,y location of points in pic 2
% Output: 
% Location center of the cloud in pic 1 and pic 2 (4x1 - colume vector)
% not ok: checking if the calculation is possible
parm_est = mean(Xsub')';
not_ok = 0;    % flag to see whether the estimation was successful   
end

function e = err_eval(parm,X)
% Input:
% Parameters (4x1 column vector) and X(Nx4 column data set)
% Output:
% error criterion using Euclidian norm
global R D
ym=X(1:2,:);% Mx2 column vectors
zm=X(3:4,:);% Mx2 column vectors
e1=(1/R)*vecnorm(ym-parm(1:2)); % error 1 of all the point - row vector
e2=(1/D)*vecnorm(zm-ym); % error 2 of all the point - row vector
e=sqrt(e1.^2+e2.^2); % Euclidian norm for row vector 
end

function ok = consistencycheck(parm,Xc,M,percentage)
global percentage
nmin = percentage*M;             % size should of consensus set should at least has
ok = (length(Xc)>=nmin);         %            a size larger than 50% of the data set                   
end