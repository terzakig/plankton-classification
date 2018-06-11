% get image histogram
function h = getHistogram(img)
% INPUT
% img: the image

% OUTPUT
% h: the histogram
[rows, cols] = size(img);
h = zeros(1, 256); 
for r = 1:rows
    for c = 1:cols
        index = 1 + double(img(r, c));
        h(index) = h(index) + 1;
    end
end

% normalizing
Z = rows * cols;
h = h / Z;