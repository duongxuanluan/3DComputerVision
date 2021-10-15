addpath('Data');
preFile = 'Aneurysm_Pre.stl';
[pre.vertices,pre.faces] = stlread(preFile);

postFile = 'Aneurysm_Post.stl';
[post.vertices,post.faces] = stlread(postFile);

[pre.vertices, indexm, indexn] =  unique(pre.vertices, 'rows');
pre.faces = indexn(pre.faces);

[post.vertices, indexm, indexn] =  unique(post.vertices, 'rows');
post.faces = indexn(post.faces);


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

xMin = 50;
xMax = 250;
yMin = 50;
yMax = 250;
zMin = 10;
zMax = 325;

nanList = find(   post.vertices(:,1) < xMin | post.vertices(:,1) > xMax | ...
        post.vertices(:,2) < yMin | post.vertices(:,2) > yMax | ...
        post.vertices(:,3) < zMin | post.vertices(:,3) > zMax);
    
post2 = post;
post2.vertices(nanList,1) = nan;
post2 = CleanNanFromFV(post2);

nanList = find(pre.vertices(:,1) < xMin | pre.vertices(:,1) > xMax | ...
        pre.vertices(:,2) < yMin | pre.vertices(:,2) > yMax | ...
        pre.vertices(:,3) < zMin | pre.vertices(:,3) > zMax);
    
pre2 = pre;
pre2.vertices(nanList,1) = nan;
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

nface = round(size(pre2.faces,1)*0.25);

[preS.vertices,presS.faces] = perform_mesh_simplification(pre2.vertices,pre2.faces,nface)


f = figure;
hold on;
p = patch('Faces',pre2.faces,'Vertices',pre2.vertices,'EdgeColor',[1 1 0],'FaceColor',[1 0.0 0],'FaceLighting','gouraud', 'FaceAlpha',0.5);
p.SpecularStrength = 0.1;
p.DiffuseStrength = 0.5;
p.AmbientStrength = 0.25;

p = patch('Faces',preS.faces,'Vertices',preS.vertices,'EdgeColor',[0 1 1],'FaceColor',[0 0.0 1],'FaceLighting','gouraud', 'FaceAlpha',0.5);
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

%%
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

intersect = TriangleRayIntersection(preS.vertices, vertexNormals, vert1, vert2, vert3);
%%
found = 0;

BestOption = zeros(size(preS.vertices,1),1);
WasHit = zeros(size(preS.vertices,1),1);

locations = zeros(size(preS.vertices));

for v=1:size(preS.vertices,1)
    orig = preS.vertices(v,:);
    dir = vertexNormals(v,:);
    [intersect,t,~,~,c] = TriangleRayIntersection(orig, dir, vert1, vert2, vert3,'lineType','line','fullReturn',1); 
    options = find(intersect);
    lengths = t(options);
    
    if (length(options) > 0)
        cc = c(options,:);
       WasHit(v) = 1; 
        [B,I] = sort(abs(lengths),'ascend');
        BestOption(v)=B(1);
        %locations(v,:) = cc(I(1),:); 
    end
end
found
%%
clear RaycastFVNormals;
[hitDistance, hitInfo] = RaycastFVNormals(uint32(post2.faces),post2.vertices,normals,normalOrigins);
sum(isnan(hitDistance))
hitPoints = hitDistance .* icoFV.vertices;


%%

f = figure;
hold on;
p = patch('Faces',preS.faces,'Vertices',preS.vertices,'EdgeColor','None','FaceColor','interp','FaceVertexCData',BestOption, 'FaceAlpha',0.5);
range = prctile(BestOption,[5 95]);

colormap jet
caxis(range)
p.SpecularStrength = 0.1;
p.DiffuseStrength = 0.5;
p.AmbientStrength = 0.25;

%scatter3(locations(:,1),locations(:,2),locations(:,3));

p = patch('Faces',post2.faces,'Vertices',post2.vertices,'EdgeColor','None','FaceColor',[0 0.0 1],'FaceLighting','gouraud', 'FaceAlpha',1);
p.SpecularStrength = 0.1;
p.DiffuseStrength = 0.5;
p.AmbientStrength = 0.25;

% light('Position',[-1 -1 1],'Style','infinite','Color',[0.5 0.5 0.5]);
% light('Position',[1 -1 1],'Style','infinite','Color',[0.5 0.5 0.5]);
% light('Position',[0 1 1],'Style','infinite','Color',[0.5 0.5 0.5]);
%             
% lighting gouraud;
daspect([1 1 1]);
 colorbar
view(135,20) 
xlabel('x-axis');
ylabel('y-axis');
zlabel('z-axis');
grid on;
hold on;
