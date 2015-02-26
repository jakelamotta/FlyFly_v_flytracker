function [x y z] = starSeed(ThisCase, NDots, Radius, MonDistance)
%function [x y z] = starSeed(ThisCase, NDots, Radius)
%
% Returns randomly generated position vector [x y z].
% ThisCase: Set-up to use. 1=cube, 2=lines, 3=sphere
% NDots: Number of dots in space
% Radius: Spread of dots in space
%

%--------------------------------------------------------------------------
% FlyFly v2
%
% Jonas Henriksson, 2010                                   info@flyfly.se
%--------------------------------------------------------------------------

switch ThisCase
    
    case 1
        % CARTESIAN COORDINATES SET-UP RAND 1
        % Cube with width 2*Radius centered around origin
        
        
        % OLOF ADDED 8 May 20011
        % If several trials are used, NDots is a vector. This
        % will create the following error message:
%           In starSeed at 21
%           In starfieldPrep at 71
%           In animationLoop at 68
%           In tableGui>run_Callback at 212
%           In gui_mainfcn at 96
%           In tableGui at 48
%           In @(hObject,eventdata)tableGui('run_Callback',hObject,eventdata,guidata(hObject))
% 
%       The original code was
%         
%         x = (2*Radius)*(rand(1, NDots) -0.5);
%         y = (2*Radius)*(rand(1, NDots) -0.5);
%         z = (2*Radius)*(rand(1, NDots) -0.5);
%         
%           New code uses only the max in NDots. Will this
%           create new errors?

         x = (2*Radius)*(rand(1, max(NDots)) -0.5);
         y = (2*Radius)*(rand(1, max(NDots)) -0.5);
         z = (2*Radius)*(rand(1, max(NDots)) -0.5);


    case 2
        % CARTESIAN COORDINATES SET-UP, 4 ROWS
        x = 5*[ones(1, NDots/4) ...
            ones(1, NDots/4) ...
            -ones(1, NDots/4) ...
            -ones(1, NDots/4)];
        
        y = 5*[ones(1, NDots/4) ...
            -ones(1,   NDots/4) ...
            ones(1,    NDots/4) ...
            -ones(1,   NDots/4)];
        
        z = [linspace(-Radius, Radius,  NDots/4) ...
            linspace(-Radius,  Radius,  NDots/4) ...
            linspace(-Radius,  Radius,  NDots/4) ...
            linspace(-Radius,  Radius,  NDots/4)];
        
    case 3
        %SPHERICAL COORDINATES SET-UP
        theta = 2*pi*rand(1, NDots);
        fi    = 2*pi*rand(1, NDots);
        r     = Radius*(rand(1, NDots));
        
        x = r.*sin(theta) .*cos(fi) + cos(theta).*cos(fi) - sin(fi);
        y = r.*sin(theta) .* sin(fi) + cos(theta).*sin(fi) + cos(fi);
        z = r.*cos(theta) - sin(theta);
        
    case 4
        % CARTESIAN COORDINATES SET-UP, 1 ROW ON Z AXIS
        x = zeros(1, NDots);        
        y = 2*ones(1, NDots);        
        z = linspace(-Radius, Radius,  NDots);

   case 5
        % CARTESIAN COORDINATES SET-UP, 1 ROW ON X AXIS
        x = linspace(-Radius, Radius,  NDots);
        y = zeros(1, NDots);        
        z = MonDistance*ones(1, NDots);   
    case 6
        % CARTESIAN COORDINATES SET-UP, CUBE IN FRONT
        x = 8*(rand(1, NDots)-0.5);
        y = 8*(rand(1, NDots)-0.5);        
        z = 8*(rand(1, NDots)-0.5);   
        
        z = z + 60;
end



