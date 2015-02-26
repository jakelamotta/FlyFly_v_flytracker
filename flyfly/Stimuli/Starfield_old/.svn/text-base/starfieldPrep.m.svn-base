function [critInput] = starfieldPrep(Parameters, ScreenData, StimSettings)
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

starfieldUserSettings; %loads user settings from file. loaded files in CAPS

[tmp, numRuns] = size(Parameters);

P.brightness  = Parameters(1,:);
P.dotSize     = Parameters(2,:);
P.nDots       = Parameters(3,:);
P.rl          = Parameters(4,:);
P.ud          = Parameters(5,:);
P.fb          = Parameters(6,:);
P.pitch       = Parameters(7,:);
P.yaw         = Parameters(8,:);
P.roll        = Parameters(9,:);

P.monWidth     = str2num(StimSettings(1).edit1{2}); %set by user
P.distance     = str2num(StimSettings(1).edit2{2}); %fly distance to screen, set by user

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
[x, y, z] = starSeed(THISCASE, P.nDots, BOXSIZE, P.distance);
%was P.viewDistance instead of BOXSIZE


z = min(z, BOXSIZE);

s = ones(numRuns, max(P.nDots)); %size array OLOF ADDED max(P.nDots) to only use max value in vector
for k = 1:numRuns
    s(k,:) = max(1, (P.dotSize(k) - P.dotSize(k)/P.viewDistance.*z)); %size array
end

critInput.rl = P.rl;
critInput.ud = P.ud;
critInput.fb = P.fb;

critInput.pitch = P.pitch;
critInput.yaw   = P.yaw;
critInput.roll  = P.roll;

critInput.D     = P.distance; %fly distance to screen

critInput.brightness = P.brightness;
critInput.dotSize    = P.dotSize;
critInput.center     = center; %center of screen to draw relative to, given by user as fly position
critInput.rect       = ScreenData.rect;

critInput.pxPerCm  = pxPerCm;
critInput.viewDist = P.viewDistance;



%Olof ADDED
critInput.constraints=CONSTRAINTDISTANCE;
critInput.drawDistance=(P.distance*P.viewDistance/2) /(P.monWidth/2);
%END added

critInput.x = x';
critInput.y = y';
critInput.z = z';
