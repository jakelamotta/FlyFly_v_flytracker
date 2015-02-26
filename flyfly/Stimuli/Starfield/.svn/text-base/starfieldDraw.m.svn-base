function Parameters = starfieldDraw(wPtr, n, k, ifi, Parameters)
%function dynamic = starfieldDraw(wPtr, n, k, Parameters, dynamic)
%
% Draws a moving cloud of dots on screen. Each dot represent a point in 
% space, [x y z], which is updated each time the function is called.
%
% Which dots are visible depend on distance to monitor, monitor width and
% view distance.
%
% "Parameters" is a struct with the following values:
%
% Parameters.rl - Translation right/left (=sideslip)
% Parameters.ud - Translation up/down (=lift)
% Parameters.fb - Translation forward/back (=thrust)
% 
% Parameters.pitch - Pitch rotation
% Parameters.yaw   - Yaw rotation
% Parameters.roll  - Roll rotation
%
% Parameters.brightness - Brightness of dots
% 
% Parameters.D - Distance to monitor
% Parameters.dotSize - Size of dots when close to viewer
% Parameters.viewDist - How far away dots are visible
%
% Parameters.center  - center of screen [x y] in px
% Parameters.pxPerCm - Pixels/cm on monitor
% 

%--------------------------------------------------------------------------
% FlyFly v2
%
% Jonas Henriksson, 2010                                   info@flyfly.se
%--------------------------------------------------------------------------

x = Parameters.x;
y = Parameters.y;
z = Parameters.z;

%ROTATE
%yaw - affects x and z
if Parameters.yaw(k) ~= 0
    [x z] = rotateXY(x, z, Parameters.yaw(k));
end

%pitch - affects y and z
if Parameters.pitch(k) ~= 0
    [y z] = rotateXY(y, z, Parameters.pitch(k));
end

%roll - affects x and y
if Parameters.roll(k) ~= 0
    [x y] = rotateXY(x, y, Parameters.roll(k));
end

%add translations
x = x + Parameters.rl(k);
y = y + Parameters.ud(k);
z = z + Parameters.fb(k);

%calculate mapped positions
xs = x.* (Parameters.D ./z) *Parameters.pxPerCm;
ys = y.* (Parameters.D ./z) *Parameters.pxPerCm;

%PROPER BUT SLOW WAY:
% alfa = atan(y./z);
% beta = pi - alfa - Parameters.gamma2;
% 
% ys   = sin(alfa)./sin(beta) * Parameters.distance2 *Parameters.pxPerCm;
% Dtmp = ys./Parameters.pxPerCm.*cos(Parameters.gamma2);
% xs   = x.*(Parameters.D+Dtmp)./z *Parameters.pxPerCm;

s    = max(1, (Parameters.dotSize(k) - Parameters.dotSize(k)/Parameters.viewDist.*z));

ys(z<=0) = 6666; %ignore objects behind us
ys(z>Parameters.viewDist) = 6666;%ignore objects to far away

%find dots on screen
c = (ys <=  (Parameters.rect(4)-Parameters.center(2))) + (ys >= -Parameters.center(2))   + ...
    (ys ~= 6666) + ...
    (xs <=  (Parameters.rect(3)-Parameters.center(1))) + (xs >= -Parameters.center(1));

c = (c==5);

%pick out visible dots with corresponding size
xs = xs(c);
ys = ys(c);
s  =  s(c);

if ~isempty(xs)
    xymatrix = [xs ys];
    
    % -Drawdots-
    Screen('DrawDots', wPtr, xymatrix', s, Parameters.brightness(k), Parameters.center,1);
%     Screen('DrawDots', wPtr, [0 0]', 10*[1], [255 0 0], Parameters.center,1); %mark center
end

%move stray objects back

% x(abs(x)> Parameters.viewDist+ abs(Parameters.rl(k)*10)) = -(x(abs(x)> Parameters.viewDist+ abs(Parameters.rl(k)*10)) +abs(Parameters.rl(k)*(rand(1,1))*10  ));
% y(abs(y)> Parameters.viewDist+ abs(Parameters.ud(k)*10)) = -(y(abs(y)> Parameters.viewDist+ abs(Parameters.ud(k)*10)) +abs(Parameters.ud(k)*(rand(1,1))*10  ));
% z(abs(z)> Parameters.viewDist+ abs(Parameters.fb(k)*10)) = -(z(abs(z)> Parameters.viewDist+ abs(Parameters.fb(k)*10)) +abs(Parameters.fb(k)*(rand(1,1))*10  ));


x(abs(x)> Parameters.viewDistX) = -(x(abs(x)> Parameters.viewDistX))*0.95;
y(abs(y)> Parameters.viewDistY) = -(y(abs(y)> Parameters.viewDistY))*0.95;
z(abs(z)> Parameters.viewDistZ) = -(z(abs(z)> Parameters.viewDistZ))*0.95;

if n == 5
    disp(['Starfield trial ' num2str(k) ': Dots on screen: ' num2str(length(xs))]);
end

%FEEDBACK
Parameters.x = x;
Parameters.y = y;
Parameters.z = z;

function [x1,y] = rotateXY(x, y, angle)
% function [x1,y1] = rotXY(x, y, angle)
%
% rotates coordinate (x, y) angle degrees around origin

x1 = x*cos(angle) - y*sin(angle);
y  = y*cos(angle) + x*sin(angle);