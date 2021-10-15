%% Use the CTRL-ENTER Method per block and corresponding questions to progress trough this file.
% DO NOT use RUN or F5 or equivalent

% Start with a clean workspace
clear variables
close all

%% Question 16
% Load the vertices and faces
[vertices,faces] = read_ply('t_hand.ply');
%% Question 17
firstFaceVertexIds = faces(1,:);
lastFaceVertexIds = faces(end,:);

% First face vertices
ffvertices = vertices(firstFaceVertexIds,:);
vf1 = ffvertices(1,:);
vf2 = ffvertices(2,:);
vf3 = ffvertices(3,:);

% Compute normal
unormalFirst = cross(vf1-vf2, vf1-vf3);
% Optional normalize normal: unormalFirst/norm(unormalFirst)

% Last faces vertices
flvertices = vertices(lastFaceVertexIds,:);
vl1 = flvertices(1,:);
vl2 = flvertices(2,:);
vl3 = flvertices(3,:);

% Compute normal
unormalLast = cross(vl1-vl2, vl1-vl3);
% Optional normalize normal: unormalLast/norm(unormalLast)

%% Question 18
% Start by getting all the normals and their orgins in a loop

% Mesh compression is NOT required but optional at this point. Uncomment if
% you want to work with a compressed mesh. Do note the differences between
% the compressed and uncompressed mesh if you do so. (EX 5_1)

% maxVertexId = length(faces)*3;
% facesDecompressed = [1:3:maxVertexId;2:3:maxVertexId;3:3:maxVertexId]';
% vericesDecompressed = vertices(faces',:);
% [vertices, indexm, indexn] =  unique(vericesDecompressed, 'rows');
% faces = indexn(facesDecompressed);

% Choose if you want to normalize or not (Try both?)
normalize = 0;

% Reserve spece for the normals and their origins (nFaces == nNormals!)
normalOrigins = zeros(size(faces,1),3);
normals =  zeros(size(faces,1),3);

% Loop
for i=1:size(faces,1)
    v1 = vertices(faces(i,1),1:3); 
    v2 = vertices(faces(i,2),1:3); 
    v3 = vertices(faces(i,3),1:3);

    % Compute origin as the average of the 3 face vertices
    normalOrigins(i,1:3) = (v1+v2+v3)/3;
    
    %Compute the normal
    unormal = cross(v1-v2, v1-v3);

    if (normalize == 1) 
        normals(i,1:3) = unormal/norm(unormal);
    else 
        normals(i,1:3) = unormal;
    end
end

% Optional parameter to scale the normals in the view
normalScaling = 10;

% Show (Also see exercise4_1)
QuickPatch(faces,vertices);

% Quiverplot with scaling
quiver3(normalOrigins(:,1),normalOrigins(:,2),normalOrigins(:,3), ...
    normals(:,1),normals(:,2),normals(:,3),normalScaling)


%% Question 19
% Mesh compression is NOT required but optional at this point. Uncomment if
% you want to work with a compressed mesh. Do note the differences between
% the compressed and uncompressed mesh if you do so. (EX 4_1)

% maxVertexId = length(faces)*3;
% facesDecompressed = [1:3:maxVertexId;2:3:maxVertexId;3:3:maxVertexId]';
% vericesDecompressed = vertices(faces',:);
% [vertices, indexm, indexn] =  unique(vericesDecompressed, 'rows');
% faces = indexn(facesDecompressed);

% Get the first face vertex ids
firstFaceVertexIds = faces(1,:);

% We use a loop since we need the vertex normals of all the vertices of
% this face. Shorter methods are available but I will mix them from time to
% time to give more insight in the computation options.
firstFaceNormals = zeros(length(firstFaceVertexIds),3);
for i=1:length(firstFaceVertexIds) % Ofcourse we know there will be 3
    id = firstFaceVertexIds(i);
    % Get all the faces with the given vertex (optional colIds)
    [faceIds colIds] = find(faces==id);
    
    % Reserve some space for the normals (optional)
    normals = zeros(length(faceIds),3);
    % Loop over
    for j=1:length(faceIds)
        % Get the vertices belonging to the face
        vertexIds = faces(faceIds(j),:);
        
        v1 = vertices(vertexIds(1),1:3); 
        v2 = vertices(vertexIds(2),1:3); 
        v3 = vertices(vertexIds(3),1:3);

        %Compute the NORMALIZED normal
        unormal = cross(v1-v2, v1-v3);
        normals(j,1:3) = unormal/norm(unormal);
    end
    
    % Get the mean normal (Per face)
    firstFaceNormals(i,:) = mean(normals);
    % Optional: Normalize
    % firstFaceNormals(i,:) = firstFaceNormals(i,:)/norm(firstFaceNormals(i,:));
end

% Get the first face vertex ids
lastFaceVertexIds = faces(end,:);

% We use a loop since we need the vertex normals of all the vertices of
% this face
lastFaceNormals = zeros(length(lastFaceVertexIds),3);
for i=1:length(lastFaceVertexIds) % Ofcourse we know there will be 3
    id = lastFaceVertexIds(i);
    % Get all the faces with the given vertex (optional colIds)
    [faceIds colIds] = find(faces==id);
    
    % Reserve some space for the normals (optional)
    normals = zeros(length(faceIds),3);
    % Loop over
    for j=1:length(faceIds)
        % Get the vertices belonging to the face
        vertexIds = faces(faceIds(j),:);
        
        v1 = vertices(vertexIds(1),1:3); 
        v2 = vertices(vertexIds(2),1:3); 
        v3 = vertices(vertexIds(3),1:3);

        %Compute the NORMALIZED normal
        unormal = cross(v1-v2, v1-v3);
        normals(j,1:3) = unormal/norm(unormal);
    end
    
    % Get the mean normal (Per face)
    lastFaceNormals(i,:) = mean(normals);
    % Optional: Normalize
    % lastFaceNormals(i,:) = lastFaceNormals(i,:)/norm(lastFaceNormals(i,:));
end

% Now we have to list of vertex normals for the first face .. 
% (firstFaceNormals) and last face (lastFaceNormals).
% Do note that per face each vertexnormal has different values!

% Fill in question 19

%% Question 20


% Mesh compression IS required at this point (Ex 4_1). Think of why!
maxVertexId = length(faces)*3;
facesDecompressed = [1:3:maxVertexId;2:3:maxVertexId;3:3:maxVertexId]';
vericesDecompressed = vertices(faces',:);
[vertices, indexm, indexn] =  unique(vericesDecompressed, 'rows');
faces = indexn(facesDecompressed);

vertexNormals = zeros(length(vertices),3);
for i=1:length(vertices) 
    id = i;
    % Get all the faces with the given vertex (optional colIds)
    [faceIds, colIds] = find(faces==id);
    
    % Reserve some space for the normals (optional)
    normals = zeros(length(faceIds),3);
    % Loop over
    for j=1:length(faceIds)
        % Get the vertices belonging to the face
        vertexIds = faces(faceIds(j),:);
        
        v1 = vertices(vertexIds(1),1:3); 
        v2 = vertices(vertexIds(2),1:3); 
        v3 = vertices(vertexIds(3),1:3);

        %Compute the NORMALIZED normal
        unormal = cross(v1-v2, v1-v3);
        normals(j,1:3) = unormal/norm(unormal);
    end
    
    % Get the mean normal (Per face)
    vertexNormals(i,:) = mean(normals);
    % Normalize
    vertexNormals(i,:) = vertexNormals(i,:) / norm(vertexNormals(i,:));
end

% Now we have to list of vertex normals for all vertices


%% Question 21

% We simply use a list of vertex ids to explore
weightedVertexIds = [10, 100, 500, 1000];

weightedVertexNormals = zeros(length(weightedVertexIds),3);
for i=1:length(weightedVertexIds) % Ofcourse we know there will be 3
    id = weightedVertexIds(i);
    % Get all the faces with the given vertex (optional colIds)
    [faceIds, colIds] = find(faces==id);
    
    % Reserve some space for the normals (optional)
    normals = zeros(length(faceIds),3);
    % Loop over
    for j=1:length(faceIds)
        % Get the vertices belonging to the face
        vertexIds = faces(faceIds(j),:);
        
        v1 = vertices(vertexIds(1),1:3); 
        v2 = vertices(vertexIds(2),1:3); 
        v3 = vertices(vertexIds(3),1:3);

        % Compute the normal
        unormal = cross(v1-v2, v1-v3);
        
        % THEOREM: a non-normalized normal computed with the method above
        % will have a vector length double that of the surface area. Hence
        % if we want to weight the vertex we can simply choose not to
        % normalize prior to computing the mean:
        % surfacearea = norm(unormal)/2;
        % normalizedNormal = unormal/norm(unormal);
        % weightedNormal = normalizedNormal * surfacearea;
        % OR:
        % weigthedNormal = unormal/2;
        % However since all the normals have 2*surfacearea as vector length
        % the devision by 2 can be applied as a final step after computing
        % the mean (As we do below).
        
        normals(j,1:3) = unormal;
    end
    
    % Get the mean normal (Per face)
    weightedVertexNormals(i,:) = mean(normals)/2;
    % Optional: Normalize. We do lose some weighting info 
    % weightedVertexNormals(i,:) = weightedVertexNormals(i,:)/norm(weightedVertexNormals(i,:));
end

% Fill in question 21

%% Question 22
% This can either be computed using weighted or unweighted vertex normals.
% You can experiment with both if you have time. In the solution we will
% use the non-weighted normals.

% Make sure your normals are normalized (in case you changed code)
vertexNormalsLength = sqrt(sum(vertexNormals.^2,2));
vertexNormals = vertexNormals./vertexNormalsLength;

% 1mm extrusion
extrusionLength = 1;

% Extrude vertices along normal:
verticesExtruded = vertices+vertexNormals*extrusionLength;

% Show
QuickPatch(faces,verticesExtruded);

%% Question 9 alternative

% 5mm extrusion
extrusionLength = 5;
% Extrude vertices along normal:
verticesExtruded = vertices+vertexNormals*extrusionLength;
% Show
QuickPatch(faces,verticesExtruded);

%% Question 23 & 24
% Fill in question 23 & 24

%% Question 25
% 1mm inward extrusion
extrusionLength = -1;
% Extrude vertices along normal:
verticesExtruded = vertices+vertexNormals*extrusionLength;
% Show
QuickPatch(faces,verticesExtruded);

% 1mm inward extrusion
extrusionLength = -5;
% Extrude vertices along normal:
verticesExtruded = vertices+vertexNormals*extrusionLength;
% Show
QuickPatch(faces,verticesExtruded);

%% Question 26 & 27
% Fill in question 26 & 27
