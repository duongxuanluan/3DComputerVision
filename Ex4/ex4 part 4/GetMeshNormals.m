function [normals, normalOrigins] = GetMeshNormals( fv, varargin)
% GetMeshNormals - Get the normals and normalOrigins of mesh faces. 
%   Returns 2 matrices with fv.faces number of rows.
%   The first return is the normals per face.
%   The second return is the normalOrigin as the center of the face.
%
% GetMeshNormals( fv, varargin)
%
% Examples:
%   Without normalization:
%       [normals, normalOrigins] = GetMeshNormals(fv);
%
%   With normalization (each normal has lenght 1):
%       [normals, normalOrigins] = GetMeshNormals(fv,'Normalize');
%
% ======================================================================= %
%
% Author & License:
%   Author:     G.A. de Jong (GDJ)
%   Contact:    Guido.dejong@radboudumc.nl
%   Licenses:   - Only for RadboudUMC employees (including interns)
%               - May not be used outside RadboudUMC Related Research
%               - Free to use for RadboudUMC Related Research
%               - Free to use for RadboudUMC Related Publications
%
%  Other Contributors:
%               None
%
% ======================================================================= %
%
% Version history:
%   2015-08-12: (GDJ) Initial version submitted
%
% ======================================================================= %
% ======================================================================= %

    normalize = 0;
    if (nargin > 1)
        for i=1:nargin-1
            if strcmp(varargin{i},'Normalize') == 1
                normalize = 1;
            end
        end
    end

    normalOrigins = zeros(size(fv.faces,1),3);
    normals =  zeros(size(fv.faces,1),3);
    for i=1:size(fv.faces,1)
        v1 = fv.vertices(fv.faces(i,1),1:3); 
        v2 = fv.vertices(fv.faces(i,2),1:3); 
        v3 = fv.vertices(fv.faces(i,3),1:3);

        normalOrigins(i,1:3) = (v1+v2+v3)/3;
        unormal = cross(v1-v2, v1-v3);

        if (normalize == 1) 
            normals(i,1:3) = unormal/norm(unormal);
        else 
            normals(i,1:3) = unormal;
        end
    end
end

