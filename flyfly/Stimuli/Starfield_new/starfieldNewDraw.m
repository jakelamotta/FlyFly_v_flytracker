%function starfieldRender(wPtr, input, k, n)
function Parameters = starfieldNewDraw(wPtr, n, k, ifi, Parameters)

Screen('DrawDots', wPtr, Parameters(k).xymatrix{n}, Parameters(k).dotsize{n}, Parameters(k).color{n}, Parameters(k).center, 1);