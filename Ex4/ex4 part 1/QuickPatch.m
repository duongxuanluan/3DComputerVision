function [p,f]=QuickPatch( faces, vertices )
f = figure;
hold on;
p = patch('Faces',faces,'Vertices',vertices,'EdgeColor','None','FaceColor',[0.8 0.8 0.8],'FaceLighting','gouraud', 'FaceAlpha',1);
p.SpecularStrength = 0.1;
p.DiffuseStrength = 0.5;
p.AmbientStrength = 0.25;

% light('Position',[-1 -1 1],'Style','infinite','Color',[0.5 0.5 0.5]);
% light('Position',[1 -1 1],'Style','infinite','Color',[0.5 0.5 0.5]);
% light('Position',[0 1 1],'Style','infinite','Color',[0.5 0.5 0.5]);
            
% lighting gouraud;
daspect([1 1 1]);
 
view(3,-8) 
camlight
xlabel('x-axis');
ylabel('y-axis');
zlabel('z-axis');
grid on;
hold on;
end

