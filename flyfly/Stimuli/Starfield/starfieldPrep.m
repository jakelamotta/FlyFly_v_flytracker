function [critInput] = starfieldPrep(Parameters, ScreenData, StimSettings, NumSubframes)
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

P.monWidth     = str2num(StimSettings(1).edit1{2});
P.distance     = str2num(StimSettings(1).edit2{2});

P.monHeight = P.monWidth * ScreenData.rect(4)/ScreenData.rect(3);
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

critInput.nDots = P.nDots;
