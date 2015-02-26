function Parameters = newMultiGratDraw(wPtr, n, k, ifi, Parameters)
%function tmp = newMultiGratDraw(wPtr, n, k, Parameters, tmp)
%
% Draws a sum of sine waves grating.
% Written based on matSequenceDraw.

%--------------------------------------------------------------------------
% FlyFly v2
%
% Jonas Henriksson, 2010                            info@flyfly.se
%--------------------------------------------------------------------------

srcRect = [];
dstRect = Parameters.dstRect(:,k);

Screen('DrawTexture', wPtr, Parameters.textures(Parameters.textureIndex(k), mod( ceil(Parameters.nSwitch(k)*n),Parameters.numFrames(k))+1), srcRect, dstRect);