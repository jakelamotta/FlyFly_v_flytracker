function output = starfieldCalc(Parameters, ScreenData, StimSettings, NumSubframes, impulse)
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

starfieldUserSettings; %loads user settings from file. loaded files in CAPS

[~, numRuns] = size(Parameters);

P.brightness  = Parameters(1,:);
P.dotSize     = Parameters(2,:);
P.nDots       = Parameters(3,:);
P.rl          = Parameters(4,:)/NumSubframes;
P.ud          = Parameters(5,:)/NumSubframes;
P.fb          = Parameters(6,:)/NumSubframes;
P.pitch       = Parameters(7,:)/NumSubframes;
P.yaw         = Parameters(8,:)/NumSubframes;
P.roll        = Parameters(9,:)/NumSubframes;
P.t           = Parameters(10,:);   % Number of frames

P.monHeight    = ScreenData.monitorHeight;
P.distance     = ScreenData.flyDistance;

P.monWidth = P.monHeight * ScreenData.rect(3)/ScreenData.rect(4);
P.viewDistance = VIEWDISTANCE;

P.dotSize      = max(1, P.dotSize);    %min size of dots in drawDots = 1
P.dotSize      = min(63.3, P.dotSize); %max size of dots in drawDots = 63

ifi = ScreenData.ifi;
pxPerCm = ScreenData.rect(3) ./ P.monWidth;


%[center(1), center(2)] = RectCenter(ScreenData.rect);
center = ScreenData.flyPos(1:2);

%flypos = [x1 y1 x2 y2]. (x1, y1) is position/height co-ordinate, (x2, y2)
%is the point we´re looking at.

hPx = ScreenData.flyPos(4)-center(2); % px offset from center
h   = hPx/pxPerCm;

center(2) = center(2) + h*pxPerCm;

gamma1 = (atan(h/P.distance))/180*pi;
gamma2 = (pi/2 - gamma1);

distance2 = P.distance / cos(gamma1);

critInput.gamma1    = gamma1;
critInput.gamma2    = gamma2;
critInput.distance2 = distance2;

%rotation/frame
P.pitch = P.pitch/180*pi *ifi;
P.yaw   = P.yaw/180*pi   *ifi;   
P.roll  = P.roll/180*pi  *ifi;  

%transaltion/frame
P.rl    = -P.rl*ifi;
P.ud    =  P.ud*ifi;
P.fb    = -P.fb*ifi;

%get starting positions
%[x, y, z] = starSeed(THISCASE, max(P.nDots), VIEWDISTANCE, P.distance, P.monWidth, P.monHeight);

box_x = P.monWidth*P.viewDistance/P.distance;
box_y = P.monHeight*P.viewDistance/P.distance;
box_z = 2*P.viewDistance;

[x, y, z] = starSeed(max(P.nDots), box_x, box_y, box_z);

z = min(z, P.viewDistance);

s = ones(numRuns, max(P.nDots)); %size array
for k = 1:numRuns
    s(k,:) = max(1, (P.dotSize(k) - P.dotSize(k)/P.viewDistance.*z)); %size array
end

critInput.rl = P.rl;
critInput.ud = P.ud;
critInput.fb = P.fb;

critInput.pitch = P.pitch;
critInput.yaw   = P.yaw;
critInput.roll  = P.roll;

critInput.D     = P.distance;

critInput.brightness = P.brightness;
critInput.dotSize    = P.dotSize;
critInput.center     = center; %center of screen to draw relative to
critInput.rect       = ScreenData.rect;

critInput.pxPerCm  = pxPerCm;

critInput.viewDist  = P.viewDistance;
critInput.viewDistX = box_x/2;
critInput.viewDistY = box_y/2;
critInput.viewDistZ = box_z/2;

critInput.x = x';
critInput.y = y';
critInput.z = z';

critInput.t = P.t;

critInput.nDots = P.nDots;

for k=1:numRuns
    
    %N = ceil(critInput.t(k)/ScreenData.ifi)
    N = critInput.t(k)*NumSubframes;
    
    for n=1:N
        
        if (impulse && n>1)
            output(k).xymatrix{n} = output(k).xymatrix{n-1};
            output(k).s{n} = output(k).s{n-1};
        else

            x = critInput.x;
            y = critInput.y;
            z = critInput.z;

            %ROTATE
            %yaw - affects x and z
            if critInput.yaw(k) ~= 0
                [x z] = rotateXY(x, z, critInput.yaw(k));
            end

            %pitch - affects y and z
            if critInput.pitch(k) ~= 0
                [y z] = rotateXY(y, z, critInput.pitch(k));
            end

            %roll - affects x and y
            if critInput.roll(k) ~= 0
                [x y] = rotateXY(x, y, critInput.roll(k));
            end

            %TRASNLATE
            x = x + critInput.rl(k);
            y = y + critInput.ud(k);
            z = z + critInput.fb(k);

            %calculate mapped positions
            xs = x.* (critInput.D ./z) *critInput.pxPerCm;
            ys = y.* (critInput.D ./z) *critInput.pxPerCm;

            s    = max(1, (critInput.dotSize(k) - critInput.dotSize(k)/critInput.viewDist.*z));

            ys(z<=0) = 6666; %ignore objects behind us
            ys(z>critInput.viewDist) = 6666;%ignore objects to far away

            %find dots on screen
            c = (ys <=  (critInput.rect(4)-critInput.center(2))) + (ys >= -critInput.center(2))   + ...
                (ys ~= 6666) + ...
                (xs <=  (critInput.rect(3)-critInput.center(1))) + (xs >= -critInput.center(1));

            c = (c==5);

            %pick out visible dots with corresponding size
            xs = xs(c);
            ys = ys(c);
            s  =  s(c);

            output(k).xymatrix{n} = [xs ys]';
            output(k).s{n} = s;

            %move stray objects back

            x(abs(x)> critInput.viewDistX) = -(x(abs(x)> critInput.viewDistX));
            y(abs(y)> critInput.viewDistY) = -(y(abs(y)> critInput.viewDistY));
            z(abs(z)> critInput.viewDistZ) = -(z(abs(z)> critInput.viewDistZ));

    %         if n == 5
    %             disp(['Starfield trial ' num2str(k) ': Dots on screen: ' num2str(length(xs))]);
    %         end

            %FEEDBACK
            critInput.x = x;
            critInput.y = y;
            critInput.z = z;
        end
    end
    
    %output(k).brightness = [ones(1,3)*critInput.brightness(k) 100];
    output(k).brightness = critInput.brightness(k);
    output(k).center = critInput.center;
end

function [x1,y] = rotateXY(x, y, angle)
% function [x1,y1] = rotXY(x, y, angle)
%
% rotates coordinate (x, y) angle degrees around origin

x1 = x*cos(angle) - y*sin(angle);
y  = y*cos(angle) + x*sin(angle);