% eventually I decided to make this a function...
% I don't trust matlab expressions.... It just takes any range to [0,1]
function imgs =  scaleImageRange(dimg)

dimgMax = max(dimg(:));
dimgMin = min(dimg(:));

range = dimgMax - dimgMin;

imgs = (dimg - dimgMin) / range;