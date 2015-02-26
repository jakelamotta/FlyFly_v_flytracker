%function starfieldRender(wPtr, input, k, n)
function Parameters = starfieldRender(wPtr, n, k, ifi, Parameters)

Parameters(k).xymatrix

Screen('DrawDots', wPtr, Parameters(k).xymatrix{n}, ...
    Parameters(k).s{n}, ...
    Parameters(k).brightness, Parameters(k).center, 1);