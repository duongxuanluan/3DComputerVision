%% Use the CTRL-ENTER Method per block and corresponding questions to progress trough this file.
% DO NOT use RUN or F5 or equivalent

% Start with a clean workspace
clear variables
close all

%% Question 28
% Load the vertices and faces
filename = 'ICO-Blob.STL';
[fv.vertices,fv.faces] = stlread(filename);
%% Question 29(See 4_1 for comments)

% Decompression phase
maxVertexId = length(fv.faces)*3;
facesDecompressed = [1:3:maxVertexId;2:3:maxVertexId;3:3:maxVertexId]';
vericesDecompressed = fv.vertices(fv.faces',:);
% Compression phase
[fv.vertices, indexm, indexn] =  unique(vericesDecompressed, 'rows');
fv.faces = indexn(facesDecompressed);

%% Question 30
QuickPatch(fv.faces,fv.vertices)

%% Question 31
% Add third ring method (second argument = 1)
% Smoothing = 1 (third arg)
[Cmean,Cgaussian,Dir1,Dir2,Lambda1,Lambda2]=patchcurvature(fv,1,1);

%% Question 32a CHOOSE an appropiate minValue and maxValue based on the given values for Mean
C=Cmean;
% Some helpful values in helping choosing the axis values
cMean = nanmean(C); cStd = nanstd(C); minVal = min(C); maxVal = max(C); range = prctile(C,[5 95]);

meanAxisRange = [minVal maxVal];
meanAxisRange = range;
%% Question 32b  CHOOSE an appropiate minValue and maxValue based on the given values for Gaussian
C=Cgaussian;
% Some helpful values in helping choosing the axis values
cMean = nanmean(C); cStd = nanstd(C); minVal = min(C); maxVal = max(C); range = prctile(C,[5 95]);

% Fill in below:
gaussAxisRange = [minVal maxVal];
gaussAxisRange = range;
%% Question 32c  CHOOSE an appropiate minValue and maxValue based on the given values for Lambda1
C=Lambda1;
% Some helpful values in helping choosing the axis values
cMean = nanmean(C); cStd = nanstd(C); minVal = min(C); maxVal = max(C); range = prctile(C,[5 95]);

% Fill in below:
l1AxisRange = [minVal maxVal];
l1AxisRange = range;
%% Question 32d  CHOOSE an appropiate minValue and maxValue based on the given values for Lambda2
C=Lambda2;
% Some helpful values in helping choosing the axis values
cMean = nanmean(C); cStd = nanstd(C); minVal = min(C); maxVal = max(C); range = prctile(C,[5 95]);

% Fill in below:
l2AxisRange = [minVal maxVal];
l2AxisRange = range;
%% Question 5 e
% For ease we make a 2x2 plot to show all in one view
rows = 2;
cols = 2;

% Create a 2x2 figure with appropiate titles
figure;

% Plot Mean
s1 = subplot(cols,rows,1), title('Mean Curvature');
p1 = patch(fv,'FaceColor','interp','FaceVertexCData',Cmean,'edgecolor','none');
axis equal; view(3)
caxis(meanAxisRange);
colormap jet
colorbar
grid on;

% Plot Gaussian
s2 = subplot(cols,rows,2), title('Gaussian Curvature');
p2 = patch(fv,'FaceColor','interp','FaceVertexCData',Cgaussian,'edgecolor','none');
axis equal; view(3)
colormap jet
caxis(gaussAxisRange);
colorbar
grid on;

% Plot L1
s3 = subplot(cols,rows,3), title('Lambda1 Curvature');
p3 = patch(fv,'FaceColor','interp','FaceVertexCData',Lambda1,'edgecolor','none');
axis equal; view(3)
colormap jet
caxis(l1AxisRange);
colorbar
grid on;

% Plot L2
s4 = subplot(cols,rows,4), title('Lambda2 Curvature');
p4 = patch(fv,'FaceColor','interp','FaceVertexCData',Lambda2,'edgecolor','none');
axis equal; view(3)
colormap jet
caxis(l2AxisRange);
colorbar
grid on;

% Fill in question 32

%% Question 33-36
% Fill in questions 33-36

%% Question 37: below the code for computing the radius of all vertices is given:
signList = -2*(sign(Lambda1) == -1 & sign(Lambda2) == -1)+1;
eqGauss = sqrt(1./abs(Cgaussian)).*signList;
% To answer the questions:
% 1) use the datatip in the figure, created in question 32, to select a vertex.
% 2) export the position of the datatip to the workspace, i,e. to the variable "cursor_info".
% 3) find the index of vertex by comparing the x-position of the selected vertex: 
%         ind = find(cursor_info.Position(1)==fv.vertices(:,1));
% 4) find the radius:   eqGauss(ind)

%% Question 38 
clear variables
close all

% Load the vertices and faces
filename = 'Skin_SMTHF.stl';
[fv.vertices,fv.faces] = stlread(filename);

% Decompression phase
maxVertexId = length(fv.faces)*3;
facesDecompressed = [1:3:maxVertexId;2:3:maxVertexId;3:3:maxVertexId]';
vericesDecompressed = fv.vertices(fv.faces',:);

% Compression phase
[fv.vertices, indexm, indexn] =  unique(vericesDecompressed, 'rows');
fv.faces = indexn(facesDecompressed);

%% Question 39
[Cmean,Cgaussian,Dir1,Dir2,Lambda1,Lambda2]=patchcurvature(fv,1,1);

%% Question 39a CHOOSE an appropiate minValue and maxValue based on the given values for Mean
C=Cmean;
% Some helpful values in helping choosing the axis values
cMean = nanmean(C); cStd = nanstd(C); minVal = min(C); maxVal = max(C); range = prctile(C,[5 95]);

% Fill in below:
meanAxisRange = range;
%% Question 39b  CHOOSE an appropiate minValue and maxValue based on the given values for Gaussian
C=Cgaussian;
% Some helpful values in helping choosing the axis values
cMean = nanmean(C); cStd = nanstd(C); minVal = min(C); maxVal = max(C); range = prctile(C,[5 95]);

% Fill in below:
gaussAxisRange = range;
%% Question 39c  CHOOSE an appropiate minValue and maxValue based on the given values for Lambda1
C=Lambda1;
% Some helpful values in helping choosing the axis values
cMean = nanmean(C); cStd = nanstd(C); minVal = min(C); maxVal = max(C); range = prctile(C,[5 95]);

% Fill in below:
l1AxisRange = range;
%% Question 39d  CHOOSE an appropiate minValue and maxValue based on the given values for Lambda2
C=Lambda2;
% Some helpful values in helping choosing the axis values
cMean = nanmean(C); cStd = nanstd(C); minVal = min(C); maxVal = max(C); range = prctile(C,[5 95]);

% Fill in below:
l2AxisRange = range;
%% Question 39 continued
rows = 2;
cols = 2;

figure;
s1 = subplot(cols,rows,1), title('Mean Curvature');
p1 = patch(fv,'FaceColor','interp','FaceVertexCData',Cmean,'edgecolor','none');
axis equal; view(3)

caxis(meanAxisRange);
colormap(jet(128))
colorbar
grid on;
hold on;

s2 = subplot(cols,rows,2), title('Gaussian Curvature');
p2 = patch(fv,'FaceColor','interp','FaceVertexCData',Cgaussian,'edgecolor','none');
axis equal; view(3)
caxis(gaussAxisRange);
colormap(jet(128))
colorbar
grid on;

s3 = subplot(cols,rows,3), title('Lambda1 Curvature');
p3 = patch(fv,'FaceColor','interp','FaceVertexCData',Lambda1,'edgecolor','none');
axis equal; view(3)
colormap(jet(128))
caxis(l1AxisRange);
colorbar
grid on;

s4 = subplot(cols,rows,4), title('Lambda2 Curvature');
p4 = patch(fv,'FaceColor','interp','FaceVertexCData',Lambda2,'edgecolor','none');
axis equal; view(3)
colormap(jet(128))
caxis(l2AxisRange);
colorbar
grid on;

% Fill in question 40


%% Question 41

% The computation (as given)
Kc = (2/pi)*atan((Lambda1+Lambda2)./(Lambda1-Lambda2));

% Colormap choice
range = prctile(Kc,[5 95]);
rr = max(abs(range));

% Plot
figure;
title('Concave versus convex');
p1 = patch(fv,'FaceColor','interp','FaceVertexCData',Kc,'edgecolor','none');
axis equal; view(3)
caxis([-rr rr]);
%caxis([-1 1]);
colormap(jet(128))
colorbar
grid on;
print -r600 -djpeg q41.jpg

%% Question 42 

% Modify the code parameters of Question 39 and/or 41 for
% theorizing about your answer

% Fill in question 42