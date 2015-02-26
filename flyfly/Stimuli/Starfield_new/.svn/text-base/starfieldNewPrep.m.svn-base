function output = starfieldCalc(Parameters, ScreenData, StimSettings, NumSubframes)
%function [critInput, dynamic] = starfieldPrep(Parameters, ScreenData,
%                                StimSettings)
%
% Takes input from the user inteface and makes pre computations.
%

%--------------------------------------------------------------------------
% FlyFly v2
%
% Jonas Henriksson, 2010                                   info@flyfly.se
%--------------------------------------------------------------------------

if nargin<4
    NumSubframes = 1;
end

global GL;

starfieldUserSettings; %loads user settings from file. loaded files in CAPS

[~, numRuns] = size(Parameters);

P.dotSize     = Parameters(1,:);
P.nDots       = Parameters(2,:);
P.rl          = Parameters(3,:)/NumSubframes;
P.ud          = Parameters(4,:)/NumSubframes;
P.fb          = Parameters(5,:)/NumSubframes;
P.pitch       = Parameters(6,:)/NumSubframes;
P.yaw         = Parameters(7,:)/NumSubframes;
P.roll        = Parameters(8,:)/NumSubframes;
P.t           = Parameters(9,:)*NumSubframes;

% z-clipping planes
zFar = 200;
zNear = 3;
% Field of view (y)
fovy = 2*atand(0.5*ScreenData.monitorHeight/ScreenData.flyDistance);
% Aspect ratio
ar = ScreenData.rect(3) / ScreenData.rect(4);

P.monHeight    = ScreenData.monitorHeight;

P.monWidth = P.monHeight * ar;
P.viewDistance = zFar;

P.dotSize      = min(max(1, P.dotSize),63);    %min size of dots in drawDots = 1, max = 63

ifi = ScreenData.ifi;
pxPerCm = ScreenData.rect(4) ./ P.monHeight;

%[center(1), center(2)] = RectCenter(ScreenData.rect);
center = ScreenData.flyPos(1:2);

hPx = ScreenData.flyPos(4)-center(2); % px offset from center
h   = hPx/pxPerCm;

cameraLookAt = [(ScreenData.flyPos(3:4)-ScreenData.flyPos(1:2))./pxPerCm ScreenData.flyDistance];
tiltAngleX = atand(((ScreenData.flyPos(3)-ScreenData.flyPos(1))./pxPerCm)/ScreenData.flyDistance)
tiltAngleY = atand(((ScreenData.flyPos(4)-ScreenData.flyPos(2))./pxPerCm)/ScreenData.flyDistance)

center(2) = center(2) + h*pxPerCm;

gamma1 = (atan(h/ScreenData.flyDistance))/180*pi;
gamma2 = (pi/2 - gamma1);

%rotation/frame
P.pitch = P.pitch/180*pi *ifi;
P.yaw   = P.yaw/180*pi   *ifi;   
P.roll  = P.roll/180*pi  *ifi;  

%transaltion/frame
P.rl    = -P.rl*ifi;
P.ud    =  P.ud*ifi;
P.fb    = -P.fb*ifi;

box_x = P.monWidth*P.viewDistance/ScreenData.flyDistance;
box_y = P.monHeight*P.viewDistance/ScreenData.flyDistance;
box_z = 2*P.viewDistance;

[x, y, z] = starSeed(max(P.nDots), box_x, box_y, box_z);

z = min(z, P.viewDistance);

P.viewDistX = box_x/2;
P.viewDistY = box_y/2;
P.viewDistZ = box_z/2;

Screen('BeginOpenGL', ScreenData.wPtr);

glViewport(0, 0, ScreenData.rect(3), ScreenData.rect(4));

glDisable(GL.LIGHTING);

glEnable(GL.BLEND);
glBlendFunc(GL.SRC_ALPHA, GL.ONE_MINUS_SRC_ALPHA);

glMatrixMode(GL.PROJECTION);
glLoadIdentity;

gluPerspective(fovy, ar, zNear, zFar);

% glRotatef(-tiltAngleX,1,0,0);
% glRotatef(tiltAngleY,0,1,0);

glMatrixMode(GL.MODELVIEW);
glLoadIdentity;

gluLookAt(0,0,0,cameraLookAt(1),cameraLookAt(2),cameraLookAt(3),0,1,0);
%gluLookAt(0,0,0,0,0,1,0,1,0);

% These are used in gluProject (3d -> 2d coordinates)
% Get the projection matrix
projection = glGetDoublev(GL.PROJECTION_MATRIX);
projectionMatrix = reshape(projection,4,4);
% Get the modelview matrix
modelview = glGetDoublev(GL.MODELVIEW_MATRIX);
modelviewMatrix = reshape(modelview,4,4);
% Get the viewport
viewport = glGetIntegerv(GL.VIEWPORT);
viewport = double(viewport);

output(numRuns) = struct('xymatrix',[],'color',[],'dotsize',[],'center',[]);

for k=1:numRuns

    N = P.t(k);
    sx = cell(1,N);
    sy = cell(1,N);
    sz = cell(1,N);
    output(k).color = cell(1,N);
    output(k).dotsize = cell(1,N);
    output(k).xymatrix = cell(1,N);
    
    for n=1:N
        %ROTATE
        %yaw - affects x and z
        if P.yaw(k) ~= 0
            [x z] = rotateXY(x, z, P.yaw(k));
        end

        %pitch - affects y and z
        if P.pitch(k) ~= 0
            [y z] = rotateXY(y, z, P.pitch(k));
        end

        %roll - affects x and y
        if P.roll(k) ~= 0
            [x y] = rotateXY(x, y, P.roll(k));
        end

        disp('translate'), tic
        %TRASNLATE
        x = x + P.rl(k);
        y = y + P.ud(k);
        z = z + P.fb(k);
        toc

        disp('move'), tic
        % Move stray objects back
        x(abs(x)> P.viewDistX) = -(x(abs(x)> P.viewDistX));
        y(abs(y)> P.viewDistY) = -(y(abs(y)> P.viewDistY));
        z(abs(z)> P.viewDistZ) = -(z(abs(z)> P.viewDistZ));
        toc

        disp('culling'), tic
        % Frustum culling, [fx; fy; fz] are all the points that are inside the
        % frustum
        % http://www.lighthouse3d.com/tutorials/view-frustum-culling/radar-approach-testing-points-ii/
        h = z*tand(fovy/2);
        w = h*ar;

        indices = and(z>zNear,z<zFar);
        indices = and(indices,and(y>-h,y<h));
        indices = and(indices,and(x>-w,x<w));

        fx = x(indices);
        fy = y(indices);
        fz = z(indices);
        toc

        disp('clip'), tic
        % Don't draw particles that are too far away
        distances = sqrt(fx.^2+fy.^2+fz.^2);
        indices = distances<zFar;
        fx = fx(indices);
        fy = fy(indices);
        fz = fz(indices);
        distances = distances(indices);
        toc

        disp('project'), tic
        % Project 3d coordinates to screen coordinates, project3d is a matlab
        % optimized version of glhProjectf, much faster than calling gluProject
        % in a loop
        
%         F = gpuArray([fx; fy; fz]);
%         [sx{n} sy{n}] = arrayfun(@project3d,F,modelviewMatrix,projectionMatrix,viewport);
        
        [sx{n} sy{n}] = project3d([fx; fy; fz],modelviewMatrix,projectionMatrix,viewport);
        
        output(k).xymatrix{n} = [sx{n}; sy{n}];
        toc

        % Color and size of dots
        output(k).color{n} = [zeros(3,length(fx)); 255*(1-max(min(distances./zFar,0.9),0.2))];
        %output(k).dotsize{n} = max((1-max(min(distances./zFar,1),0))*P.dotSize(k),1);
        output(k).dotsize{n} = max(min(63,P.dotSize(k)^2./distances),1);
    end
    
    output(k).center = [];
end

Screen('EndOpenGL', ScreenData.wPtr);


function [x1,y] = rotateXY(x, y, angle)
% rotates coordinate (x, y) angle degrees around origin

x1 = x*cos(angle) - y*sin(angle);
y  = y*cos(angle) + x*sin(angle);


function [winX winY] = project3d(objectPos,model,project,viewport)
% MATLAB optimzed version of glhProjectf
% (http://www.opengl.org/wiki/GluProject_and_gluUnProject_code)
% Much faster than calling gluProject in a loop
% (the glhProjectf (works only from perspective projection. With the
% orthogonal projection it gives different results than standard
% gluProject.)

temp = model(:,1:3)*objectPos + model(:,4)*ones(1,size(objectPos,2));
temp2 = project(1:3,:)*temp;
temp3 = -temp(3,:);
r = (temp3~=0);

temp2 = temp2(:,r)./(ones(3,1)*temp3(r));
winX = (temp2(1,:)*.5+.5)*viewport(3)+viewport(1);
winY = (temp2(2,:)*.5+.5)*viewport(4)+viewport(2);
%winZ = (1+temp2(3,:))*.5;