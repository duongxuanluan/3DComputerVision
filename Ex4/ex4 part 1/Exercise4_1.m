
%% exercise 4 - part 1
% Use the CTRL-ENTER Method per block and corresponding questions to progress trough this file.
% DO NOT use RUN or F5 or equivalent

%% Question 1
% Start with a clean workspace
clear variables
close all

% Load the vertices and faces
[vertices,faces] = read_ply('bunny_zipper.ply');
%% Question 2
% Fill in Question 2
% HINT: Look in the workspace or uncomment (some) of the lines below

% size(faces)
% size(vertices)
% length(faces)
% length(vertices)

%% Question 3 (First part)

% Make a figure
f = figure;
% Patch it (with some example properties)
p = patch('Faces',faces,'Vertices',vertices,'FaceColor',[0.8 0.8 0.8],'FaceLighting','gouraud');
% Example of modifying properties afterwards
p.EdgeColor = 'None';
p.SpecularStrength = 0.1;
p.DiffuseStrength = 0.5;
p.AmbientStrength = 0.25;

% Aspect ratio to 1,1,1 (x,y,z). Alternatively: axis equal
daspect([1 1 1]);
 
% Some view direction to start with
view(3,-8) 

% Add light
camlight

% Labels for extra insight
xlabel('x-axis');
ylabel('y-axis');
zlabel('z-axis');

% Grid for extra insight
grid on;


%% Question 3 (Second part)
hold on;

% Vertex id (Given 2000 instead of 1 or 1000 to have a stronger effect)
vertexId = 1; %Change to experiment with if you want 

% Show it with the scatterplot
plot3(vertices(vertexId,1),vertices(vertexId,2),vertices(vertexId,3),'r.','markersize',12);

% Face Id
faceId = 1;
% Vertices belonging to Face Id's Face
vertexIds = faces(faceId,:);
% All vertexid's coordinates (e.g. 2)
% (To get one vetex coordinate set: vertices(vertexIds(2),:)
vertexFaceCoords = vertices(vertexIds,:);

% Show it with the scatterplot
plot3(vertexFaceCoords(:,1),vertexFaceCoords(:,2),vertexFaceCoords(:,3),'y','linewidth',2);

%% Question 4

% The highest new vertex id will be 3* nFaces
nFaces = size(faces,1); %Alternative: length(faces)
maxVertexId = nFaces*3;

% Create a list with faces ([1 2 3; 4 5 6; . . .; n-5 n-4 n-3; n-2 n-1 n];
% Alternatively this can be created with a loop or other methods
facesDecompressed = [1:3:maxVertexId;2:3:maxVertexId;3:3:maxVertexId]';

% Create a new vertex list by refering to the faces (transposed)
% This creates a list where the first vertex has the coordinates of ...
% those of vertices(faces(1,1),:) and the second of vertices(faces(1,2),:)
% Alternatively this can be created with a loop (growing) or ..
% prefixed (e.g. verticesDecrompressed = zeros(maxVertexId,3) )
verticesDecompressed = vertices(faces',:);

%% Question 5
% From now on I will use the (provided) function QuickPatch to quickly plot
% a patch to avoid code-cluttering
% Note that Quickpatch ends with a "hold on"!!!

% Show
QuickPatch( facesDecompressed, verticesDecompressed );

% Similar setup as in Question 3, with different set so no comments provided
% Vertex plot
vertexId = 2000;
plot3(verticesDecompressed(vertexId,1),verticesDecompressed(vertexId,2),verticesDecompressed(vertexId,3),'r.','markersize',12);

% Face plot
faceId = 2000;
vertexIds = facesDecompressed(faceId,:);
vertexFaceCoords = verticesDecompressed(vertexIds,:);

% Show it with the scatterplot
plot3(vertexFaceCoords(:,1),vertexFaceCoords(:,2),vertexFaceCoords(:,3),'y','linewidth',2);
%% Question 6
% Fill in Question 6

% Hint: Also try to look at the exact coordinates of your vertex
% Alternatively change the vertexId and faceId

%% Question 7
% Compression is in two steps. First we get all the unique vertices
[verticesCompressed, indexm, indexn] =  unique(verticesDecompressed, 'rows');

% [C,ia,ic] = unique(___)
% If the 'rows' option is specified, then C = A(ia,:) and A = C(ic,:).

% indexm gives the original id's of the vertices used. This means that ...
% vericesDecompressed(indexm(1),:) will be the verticesCompressed(1,:)

% indexn gives the new id's of the vertices used. This means that ... 
% verticesCompressed(indexn(1),:) will be the vericesDecompressed(1,:)

% Using facesDecompressed as a lookup table with indexn we get the new ...
% faces list. Alternatively loops can be used.
facesCompressed = indexn(facesDecompressed);

%% Question 8

QuickPatch( facesCompressed, verticesCompressed );
% Similar setup as in Question 3 & 5, with different set so no comments provided
% Vertex plot
plot3(verticesCompressed(vertexId,1),verticesCompressed(vertexId,2),verticesCompressed(vertexId,3),'r.','markersize',12);

% Face plot
vertexIds = facesCompressed(faceId,:);
vertexFaceCoords = verticesCompressed(vertexIds,:);

% Show it with the scatterplot
plot3(vertexFaceCoords(:,1),vertexFaceCoords(:,2),vertexFaceCoords(:,3),'y','linewidth',2);
%% Question 9-15
% You should have all the materials for question 9-15
% Answer questions 9-15