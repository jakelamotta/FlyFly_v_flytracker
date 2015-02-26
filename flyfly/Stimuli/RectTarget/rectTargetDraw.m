function Parameters = rectTargetDraw(wPtr, n, k, ifi, Parameters)
%Parameters: RGB, POSITION, DELTAPOSITION
%Draw a rect in wPtr to position, modified by n*deltaPosition
%

%--------------------------------------------------------------------------
% FlyFly v2
%
% Jonas Henriksson, 2010                                     info@flyfly.se
%--------------------------------------------------------------------------

Screen('FillRect', wPtr, Parameters.RGB(:,k) , Parameters.pos(:,k) + (n-1)*Parameters.deltaPos(:,k));