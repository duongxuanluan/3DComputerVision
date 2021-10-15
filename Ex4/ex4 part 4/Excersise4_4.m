%% Use the CTRL-ENTER Method per block and corresponding questions to progress trough this file.
% DO NOT use RUN or F5 or equivalent
% Start with a clean workspace
clear variables
close all

%% Question 43

% Assuming all pacakges and files are extracted in data
addpath('Data');

% Load the vertices and faces of both aneurysms
preFile = 'Aneurysm_Pre.stl';
[pre.vertices,pre.faces] = stlread(preFile);

postFile = 'Aneurysm_Post.stl';
[post.vertices,post.faces] = stlread(postFile);

% Decompress and Compress
maxVertexId = length(pre.faces)*3;
facesDecompressed = [1:3:maxVertexId;2:3:maxVertexId;3:3:maxVertexId]';
vericesDecompressed = pre.vertices(pre.faces',:);
[pre.vertices, indexm, indexn] =  unique(pre.vertices, 'rows');
pre.faces = indexn(pre.faces);

% Decompress and Compress
maxVertexId = length(post.faces)*3;
facesDecompressed = [1:3:maxVertexId;2:3:maxVertexId;3:3:maxVertexId]';
vericesDecompressed = post.vertices(post.faces',:);
[post.vertices, indexm, indexn] =  unique(post.vertices, 'rows');
post.faces = indexn(post.faces);
%% Question 43a
% Visualize anuerysms
f = figure;
hold on;
p = patch('Faces',pre.faces,'Vertices',pre.vertices,'EdgeColor','None','FaceColor',[1 0.0 0],'FaceLighting','gouraud', 'FaceAlpha',0.5);
p.SpecularStrength = 0.1;
p.DiffuseStrength = 0.5;
p.AmbientStrength = 0.25;

p = patch('Faces',post.faces,'Vertices',post.vertices,'EdgeColor','None','FaceColor',[0 0.0 1],'FaceLighting','gouraud', 'FaceAlpha',0.5);
p.SpecularStrength = 0.1;
p.DiffuseStrength = 0.5;
p.AmbientStrength = 0.25;

light('Position',[-1 -1 1],'Style','infinite','Color',[0.5 0.5 0.5]);
light('Position',[1 -1 1],'Style','infinite','Color',[0.5 0.5 0.5]);
light('Position',[0 1 1],'Style','infinite','Color',[0.5 0.5 0.5]);
            
lighting gouraud;
daspect([1 1 1]);
 
view(135,20) 
xlabel('x-axis');
ylabel('y-axis');
zlabel('z-axis');
grid on;
hold on;
%% Question 44a Choose bounds
xMin = 50;
xMax = 300;
yMin = 30;
yMax = 225;
zMin = 0;
zMax = 300;

%% Question 44b


% Remove vertices from bounds of Post
nanList = find(   post.vertices(:,1) < xMin | post.vertices(:,1) > xMax | ...
        post.vertices(:,2) < yMin | post.vertices(:,2) > yMax | ...
        post.vertices(:,3) < zMin | post.vertices(:,3) > zMax);
    
post2 = post;
post2.vertices(nanList,1) = nan;

% Helper function
post2 = CleanNanFromFV(post2);

% Remove vertices from bounds of Pre
nanList = find(pre.vertices(:,1) < xMin | pre.vertices(:,1) > xMax | ...
        pre.vertices(:,2) < yMin | pre.vertices(:,2) > yMax | ...
        pre.vertices(:,3) < zMin | pre.vertices(:,3) > zMax);
    
pre2 = pre;
pre2.vertices(nanList,1) = nan;
% Helper function to remove (look in the code for details)
pre2 = CleanNanFromFV(pre2);


f = figure;
hold on;
p = patch('Faces',pre2.faces,'Vertices',pre2.vertices,'EdgeColor','None','FaceColor',[1 0.0 0],'FaceLighting','gouraud', 'FaceAlpha',0.5);
p.SpecularStrength = 0.1;
p.DiffuseStrength = 0.5;
p.AmbientStrength = 0.25;

p = patch('Faces',post2.faces,'Vertices',post2.vertices,'EdgeColor','None','FaceColor',[0 0.0 1],'FaceLighting','gouraud', 'FaceAlpha',0.5);
p.SpecularStrength = 0.1;
p.DiffuseStrength = 0.5;
p.AmbientStrength = 0.25;

light('Position',[-1 -1 1],'Style','infinite','Color',[0.5 0.5 0.5]);
light('Position',[1 -1 1],'Style','infinite','Color',[0.5 0.5 0.5]);
light('Position',[0 1 1],'Style','infinite','Color',[0.5 0.5 0.5]);
            
lighting gouraud;
daspect([1 1 1]);
 
view(135,20) 
xlabel('x-axis');
ylabel('y-axis');
zlabel('z-axis');
grid on;
hold on;

% Fill in question 44

%% Question 45
addpath(genpath('toolbox_graph'));

reduction = 0.1; %Fill in your own reduction amount (% of total)

% get the number of faces based on the reduction
nface = round(size(pre2.faces,1)*reduction);

% Simplify
[preS.vertices,preS.faces] = perform_mesh_simplification(pre2.vertices,pre2.faces,nface);
% Plot with reduced vertices and faces
f = figure;
hold on;
p = patch('Faces',preS.faces,'Vertices',preS.vertices,'EdgeColor','None','FaceColor',[1 0.0 0],'FaceLighting','gouraud', 'FaceAlpha',0.5);
p.SpecularStrength = 0.1;
p.DiffuseStrength = 0.5;
p.AmbientStrength = 0.25;

p = patch('Faces',post2.faces,'Vertices',post2.vertices,'EdgeColor','None','FaceColor',[0 0.0 1],'FaceLighting','gouraud', 'FaceAlpha',0.5);
p.SpecularStrength = 0.1;
p.DiffuseStrength = 0.5;
p.AmbientStrength = 0.25;

light('Position',[-1 -1 1],'Style','infinite','Color',[0.5 0.5 0.5]);
light('Position',[1 -1 1],'Style','infinite','Color',[0.5 0.5 0.5]);
light('Position',[0 1 1],'Style','infinite','Color',[0.5 0.5 0.5]);
            
lighting gouraud;
daspect([1 1 1]);
 
view(135,20) 
xlabel('x-axis');
ylabel('y-axis');
zlabel('z-axis');
grid on;
hold on;

% Fill in question 45

%% Question 46
addpath(genpath('TriangleRayIntersection'));

% Get mesh normals (Helper function, you can use code from earlier)
[normals, normalOrigins] = GetMeshNormals(preS, 'Normalize');

vertexNormals = zeros(size(preS.vertices));

for f=1:size(preS.faces,1)
    vertexNormals(preS.faces(f,1),:) =  vertexNormals(preS.faces(f,1),:) + normals(f,:);
    vertexNormals(preS.faces(f,2),:) =  vertexNormals(preS.faces(f,2),:) + normals(f,:);
    vertexNormals(preS.faces(f,3),:) =  vertexNormals(preS.faces(f,3),:) + normals(f,:);
end

vertexNormals = vertexNormals./repmat(sqrt(sum(vertexNormals.^2,2)),1,3);

vert1 = post2.vertices(post2.faces(:,1),:);
vert2 = post2.vertices(post2.faces(:,2),:);
vert3 = post2.vertices(post2.faces(:,3),:);

% Reserve space for raycast hits
raycastHitLength = zeros(size(preS.vertices,1),1);
% Loop over the vertices of the simplified mesh (as rays)
for v=1:size(preS.vertices,1)
    % Get the origin (From the vertex)
    orig = preS.vertices(v,:);
    % Get the direction (From the vertex normal)
    dir = vertexNormals(v,:);
    [intersect,t,~,~,c] = TriangleRayIntersection(orig, dir, vert1, vert2, vert3,'lineType','line','fullReturn',1); 
    % Find the intersections
    options = find(intersect);
    % Find the length of these intersections
    lengths = t(options);
    
    % If we have a hit
    if (length(options) > 0)
        % Get the shortest hit
        [B,I] = sort(abs(lengths),'ascend');
        % Store the hit
        raycastHitLength(v)=B(1);
    end
end
%% Question 47
f = figure;
hold on;
p = patch('Faces',preS.faces,'Vertices',preS.vertices,'EdgeColor','None','FaceColor','interp','FaceVertexCData',raycastHitLength, 'FaceAlpha',0.5);
range = prctile(raycastHitLength,[5 95]);

colormap jet
caxis(range)
p.SpecularStrength = 0.1;
p.DiffuseStrength = 0.5;
p.AmbientStrength = 0.25;

p = patch('Faces',post2.faces,'Vertices',post2.vertices,'EdgeColor','None','FaceColor',[0 0.0 1],'FaceLighting','gouraud', 'FaceAlpha',1);
p.SpecularStrength = 0.1;
p.DiffuseStrength = 0.5;
p.AmbientStrength = 0.25;

daspect([1 1 1]);
 colorbar
view(135,20) 
xlabel('x-axis');
ylabel('y-axis');
zlabel('z-axis');
grid on;
hold on;

%% Question 48

% Supress noise
range = prctile(raycastHitLength,[1 99]);

% Find highest reduction (0.34 mm voxel size)
highestReduction = range(2)*0.34;

% For the last part of the question:
% Look in the plot to determine the maximum width of the residual anuerysm
% compared to the original at the same position

% Fill in question 48