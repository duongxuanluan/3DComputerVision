% handle = ut_figure(N,H,V)
%
% Opens a new figure with the following figure properties:
% size =        HxV cm
% fontsize =    12
% fontweight =  'normal'
% fontname =    'arial'
% linewidth =   1.2
% markersize =  6
% renderer =    'opengl'
%
% Printing with the following MatLab commands:
% >>  print -depsc r600 -tiff <filename>.eps
% >>  print -dpng  r600       <filename>.png
% >>  print -djpeg r600       <filename>.jpg
% provides high quality graphs.
% 
% handle = ut_figure(N,H,V,'property',value)
%
% sets in addition the following possible figure properties:
% 'units':      'inches' | 'centimeters' | 'normalized' | 'points' | 'pixels' | 'characters'
% 'fontsize':	Font size specified in FontUnits
% 'renderer':   'painters' | 'zbuffer' | 'OpenGL'



function f=ut_figure(varargin)

[f,H,V,unit,fontsize,renderer,fontname,pos] = ParseInputs(varargin{:});


fontweight = 'normal';
linewidth  = 1.2; %0.7;
markersize = 6; %3;


f = figure (f);


position 	= get (f, 'Position');
position(1) = 4; %pos(1);
position(2) = 0; %pos(2);
position(3) = H;
position(4) = V;

set (f, 'Units',unit);

set (f, 'Position', position);
set (f, 'Renderer', renderer);

% And the default values for the layout.

%set (n, 'MenuBar', 'no');

set (f, 'PaperPositionMode','auto');
set (f, 'DefaultTextFontSize',   fontsize);
set (f, 'DefaultTextFontWeight', fontweight);
set (f, 'DefaultTextFontName',   fontname);
set (f, 'DefaultTextRotation',   0);
set (f, 'DefaultAxesFontSize',   fontsize);
set (f, 'DefaultAxesFontWeight', fontweight);
set (f, 'DefaultAxesFontName',   fontname);
set (f, 'DefaultAxesBox',      'off');
set (f, 'DefaultLineMarkerSize', markersize);
set (f, 'DefaultLineLineWidth',  linewidth);

end

function [N,H,V,unit,fontsize,renderer,fontname,pos] = ParseInputs(varargin)

narginchk(3,11)
% MSG = NARGCHK(LOW,HIGH,N) returns an appropriate error message if
%    N is not between low and high. If it is, return empty matrix.

N = varargin{1};
H = varargin{2};
V = varargin{3};

%defaults
unit = 'centimeters';
fontsize = 12;
renderer = 'OpenGl';
fontname = 'timesroman';
pos = [1 1];


options = {'units','u','fontsize','f','renderer','r','fontname','position','p','Position'};
if nargin>3
    k = 4;
    while(k<nargin)
        if ischar(varargin{k})
            string = lower(varargin{k});
            j = strmatch(string,options,'exact');
            if isempty(j)
                error(['Invalid input string: ''' varargin{k} '''.']);
            end
            switch string
                case {'units','u'}
                    if nargin>k && ischar(varargin{k+1})
                        unit = varargin{k+1};
                        k=k+2;
                    else
                        error(['char array expected after string: ''' varargin{k} '''.']);
                    end
                case {'position','p','Position','pos'}
                    if nargin>k && isnumeric(varargin{k+1})
                        pos = varargin{k+1};
                        k=k+2;
                    else
                        error(['char array expected after string: ''' varargin{k} '''.']);
                    end
                case {'fontsize','f'}
                    if nargin>k && isnumeric(varargin{k+1})
                        fontsize = varargin{k+1};
                        k=k+2;
                    else
                        error(['Numerical expected after string: ''' varargin{k} '''.']);
                    end
                case {'renderer','r'}
                    if nargin>k && ischar(varargin{k+1})
                        renderer = varargin{k+1};
                        k=k+2;
                    else
                        error(['char array expected after string: ''' varargin{k} '''.']);
                    end
                case {'fontname'}
                    if nargin>k && ischar(varargin{k+1})
                        fontname = varargin{k+1};
                        k=k+2;
                    else
                        error(['char array expected after string: ''' varargin{k} '''.']);
                    end
            end
        else
            k=k+1;
        end
    end
end
end


