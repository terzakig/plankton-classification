% an authothrehsold for the plankton images
function [timg, threshold] = autoThreshold(img)
% INPUT
% img: input grayscale image

% OUTPUT
% timg: thresholded image
% threshold: the detected threshold

% finding the mean
[rows, cols] = size(img);
img1 = double(img);
m = sum(sum(img1))/rows/cols;

% obtaining image histogram
h = getHistogram(img);
% the weighted image values
range = 0:255; % the range of image elements
w = h .* range;

% autothresholding looip
threshold = m; % initial threshold is the mean
prevThreshold = inf; % the previously estimated threshold
while (threshold ~= prevThreshold)
    
    lowThreshhIndex = floor(threshold)+1;
    upThreshhIndex = ceil(threshold)+1;
    
    center1 = sum(w(1:lowThreshhIndex))/sum(h((1:lowThreshhIndex)));
    center2 = sum(w(upThreshhIndex:end))/sum(h(upThreshhIndex:end));
    
    % recomputing threshold
    prevThreshold = threshold;
    threshold = (center1 + center2) / 2;
end

% thresholding the image now
timg = img1 > threshold;
