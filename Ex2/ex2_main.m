%%%%% 3DCV Exercise 2: 3D surface reconstruction %%%%%%%%%%%%%

%% Summary 
% 3D surface reconstruction using:
% - left and right camera images of bending leg with patterns
% - Camera calbiration for left and right camera  
clear all; close all

%% Part 1: Camera calibration 
% 1.1 Using stereo camera calibration app in Matlab 
% The size of chessboard is 40mm
% save camp camp 
% save estimationErrors estimationErrors  
load camp
load estimationErrors

% 1.2 Calculate 1R2 and 1t2 
R21=(camp.RotationOfCamera2)'; % transpose bcz of Matlab default
R12=R21';
t21=(camp.TranslationOfCamera2)';
t12=-R21'*t21; % inverse 2R1 as formula 

% Uncertainty 
t21_unc=estimationErrors.TranslationOfCamera2Error';
t12_unc=-R21'*t21_unc;

% 1.4 Finding rotation angles and axis
axang = rotm2axang(R12);
ang_degree=rad2deg(axang(:,4));

%% Part 2: Epipolar Geometry 
%2.1 Find Essential matrix and Fundamental Matrix
T=[0 -t12(3) t12(2);t12(3) 0 -t12(1); -t12(2) t12(1) 0 ];
E=R12'*T;
%fundamental matrix
K1=camp.CameraParameters1.Intrinsics.IntrinsicMatrix;
K2=camp.CameraParameters2.Intrinsics.IntrinsicMatrix;
F=(inv(K2'))'*E*inv(K1');

%2.2 Finding epipoles
q1=null(F); 
q2=null(F');
q1=hom2cart(q1');
q2=hom2cart(q2');



%% Part 3: Data Preparation
% 3.1 Change to double data
im1=im2double(imread('ACLtestL05.png'));
im2=im2double(imread('ACLtestR05.png'));

%3.2 Segmentation: separate the background
% Using Color Threshold to create mask for the image im1 and im2
[BWmaskL,maskedRGBImage1] = createMask(im1); 
[BWmaskR,maskedRGBImage2] = createMask(im2); 

%Visualizing mask
figure (1);
imshow(BWmaskL)

Mask1=bwareafilt(BWmaskL,1);
Mask2=bwareafilt(BWmaskR,1);
Mask1=imfill(Mask1,'holes');
Mask2=imfill(Mask2,'holes');

figure(2);
imshow(Mask1)
figure(3);
imshow(Mask2)

% Applying mask

imL_noB=im1.*double(Mask1);
imR_noB=im2.*double(Mask2);

figure(4);
imshow(imL_noB);
imwrite(imL_noB,'3-2-im1.png');
figure(5);
imshow(imR_noB);
imwrite(imR_noB,'3-2-im2.png');

%% Part 4: Stereo 
% 4.1  Apply lens rectifying 
[J1, J2]=rectifyStereoImages(imL_noB,imR_noB,camp,'OutputView','full');
%cpselect(J1,J2);
imwrite(J1,'4-1-J1.png');
imwrite(J2,'4-1-J2.png');

% 4.2 Checking if the rectification was successful
[mean_angles,rms_angles] = ut_check_rect(J1,J2,['visualize']);
print('-r300', '-dpng','4-2-SuccesfulRec');

% 4.4 Virtual rotation
[Rrectc, Rrectcc,K,ctcc,Hc,Hcc] = ut_getStereo_rect_parms(camp);


%% Part 5: DISPARITY
% 5.1 Find range of disparity
% cpselect(J1,J2);
%save fixedPoints1 fixedPoints1
%save movingPoints1 movingPoints1
fixedPoints1= [862.562500000000,211.687500000000;920.937500000000,247.062500000000;830.312500000000,272.562500000000;887.937500000000,307.312500000000;474.312500000000,357.687500000000;509.687500000000,402.562500000000;482.687500000000,436.812500000000;445.312500000000,397.312500000000];
movingPoints1=[1067.93750000000,212.562500000000;1123.43750000000,247.312500000000;1036.81250000000,272.437500000000;1089.81250000000,307.312500000000;644.437500000000,357.312500000000;679.562500000000,401.437500000000;647.312500000000,436.812500000000;609.687500000000,396.562500000000];
Diff=movingPoints1-fixedPoints1; 
maxDis=max(Diff(:,1));
minDis=min(Diff(:,1));

% 5.2 
I1=rgb2gray(J1); % change to gray scale so can put for disparity map
I2=rgb2gray(J2);
disparityRange = [152 216]; % within the maxDis and minDis and dividable by 8
disparityMap = disparitySGM(I1,I2,'DisparityRange',disparityRange,...
     'UniquenessThreshold',5);
figure(6);
imshow(disparityMap,disparityRange)
colormap jet;
colorbar;
print('-r300', '-dpng','5-2-Disparity');

% 5.4 - 5.5 Mask Unreliable
unreliable=false(size(disparityMap));
for a=1:length(disparityMap(:,1))
  for b=1:length(disparityMap)
      if isnan(disparityMap(a,b))|J1(a,b)==0
         unreliable(a,b)=1;
      else
         unreliable(a,b)=0; 
      end 
  end
end
 figure(7)
 imshow(unreliable)
 
 % 5.6 Using bwareafilt
 reliable=bwareafilt(~unreliable,1);
 figure(8);
 imshow(reliable)
 unreliable=logical(unreliable+(~reliable));
 figure(9)
 imshow(unreliable)
 print('-r300', '-dpng','5-6-MaskLeg');
 
%% Part 6: POINT CLOUD
% 6.1 Reconstruct scene
points3D = reconstructScene(disparityMap,camp);
figure(10);
pcshow(points3D)
xlabel('X')
ylabel('Y')
zlabel('Z')
campos([0 0 200]);
camup([0 -1 0]);
print('-r300', '-dpng','6-1-3DPoints');
 
% 6.2 pointCloud function  
[M,N] = size(disparityMap);
%linearize the array
pcl = reshape(points3D,N*M,3);
unreliable_reshape=single(unreliable);
poc = reshape(unreliable_reshape,N*M,1);
% Masking the points
ind_unreliable= find(poc);
pcl(ind_unreliable,:)=[];

% Pointcloud 
ptCloud = pointCloud(pcl);
figure(11)
pcshow(ptCloud)
xlabel('X')
ylabel('Y')
zlabel('Z')
campos([0 0 200]);
camup([0 -1 0]);
%print('-r300', '-dpng','PointsCloud');

%% Part 7: 3D Surface Mesh
[TR] = MESH(disparityMap,unreliable,points3D,J1,10);

function [TR] = MESH(disparityMap,unreliable,points3D, J1,res)
% create a connectivity structure
[M, N] = size(disparityMap); % get image size
%res = 2; % resolution of mesh
[nI,mI] = meshgrid(1:res:N,1:res:M); % create a 2D meshgrid of pixels, thus defining a resolution grid
TRI = delaunay(nI(:),mI(:)); % create a triangle connectivity list
indI = sub2ind([M,N],mI(:),nI(:)); % cast grid points to linear indices
% linearize the arrays and adapt to chosen resolution
pcl = reshape(points3D,N*M,3); % reshape to (N*M)x3
J1l = reshape(J1,N*M,3); % reshape to (N*M)x3
pcl = pcl(indI,:); % select 3D points that are on resolution grid
J1l = J1l(indI,:); % select pixels that are on the resolution grid
% remove the unreliable points and the associated triangles 
ind_unreliable = find(unreliable(indI));% get the linear indices of unreliable 3D points
imem = ismember(TRI(:),ind_unreliable); % find indices of references to unreliable points
[ir,~] = ind2sub(size(TRI),find(imem)); % get the indices of rows with refs to unreliable points.
TRI(ir,:) = []; % dispose them
iused = unique(TRI(:)); % find the ind's of vertices that are in use
used = zeros(length(pcl),1); % pre-allocate
used(iused) = 1; % create a map of used vertices
map2used = cumsum(used); % conversion table from indices of old vertices to the new one
pcl = pcl(iused,:); % remove the unused vertices
J1l = J1l(iused,:); 
TRI = map2used(TRI); % update the ind's of vertices
% create the 3D mesh
TR = triangulation(TRI,double(pcl)); % create the object
% visualize
figure; 
TM = trimesh(TR); % plot the mesh
set(TM,'FaceVertexCData',J1l); % set colors to input image
set(TM,'FaceColor','white'); % if you want a colored surface
set(TM,'EdgeColor','black'); % suppress the edges
xlabel('x (mm)') 
ylabel('y (mm)') 
zlabel('z (mm)') 
axis([-250 250 -250 250 400 900]) 
set(gca,'xdir','reverse') 
set(gca,'zdir','reverse') 
daspect([1,1,1]) 
axis tight
end
