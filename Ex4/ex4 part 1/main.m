% Ex 4- Part 1:
[vertex,face] =read_ply('bunny_zipper.ply');
hold on
QuickPatch( face, vertex)
plot3(vertex(1,1),vertex(1,2),vertex(1,3),'ro');
A=[vertex(face(1,1),:);vertex(face(1,2),:);vertex(face(1,2),:)];
plot3(A(:,1),A(:,2),A(:,3),'bx'); 
hold off