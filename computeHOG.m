% the following functions computes the HOG of a regions in an image
function D = computeHOG(img, upLeft, lowRight, gridDim, N)
% INPUT
% img: the image
% upLeft: upper left corner of ROI
% lowRight: Lower right corner of ROI
% gridDim: dimension of the cell grid as [rows, cols]. rows and cols must be multiples of 4 (4x4 cells)
% N: The number of bins (best choice would be 9) in the histogram (assuming it is a divisor of 180)

% OUTPUT
% D: The descriptor of quantized histograms 0-180 degrees
[rows, cols] = size(img);
if (isempty(N))
    numBins = 9;
else
    numBins = N;
end

img1 = double(img);
e = 0.01; % a regularizuing constant used for Block - normalization

%%%%%%%%%%%%%%%% Gradient in the ROI (using simple differences) %%%%%%%%%%%%%%%%%%%%%%%%%%
ROIRows = abs(upLeft(1) - lowRight(1)) + 1;
ROICols = abs(upLeft(2) - lowRight(2)) + 1;
Gx = zeros(size(img1)); Gy = zeros(size(img1)); % derivetive in x, y
% computing gradients
for r = 2:rows-2
    Gy(r, :) = img1(r + 1, :) - img1(r-1, :);
end
Gy(1,:) = img1(2, :) - img1(1, :); Gy(end, :) = img1(end, :) - img1(end-1, :);

for c = 2:cols-2
    Gx(:, c) = img1(: , c+1) - img1(: , c-1);
end
Gx(:,1) = img1(:, 2) - img1(:, 1); Gx(:, end) = img1(:, end) - img1(:, end-1);

%%%%%%%%%%%%%%%%%%%%%%%% Gradient computation done %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%% Gradient Norm and Angle %%%%%%%%%%%%%%%
normG = sqrt(Gx.^2 + Gx.^2);
angle = atand(Gy ./ Gx);
angle = angle + 90; % adding 90 because atand returns result in [-90, 90]

% fixing the "NaN" problemns
angle(isnan(angle)) = 0; normG(isnan(normG)) = 0;
%%%%%%%%%%% done computing gradient magintude and angle %%%%%%%%%%%%%

% computing the descriptor  now
D = [];
bin_size = 180.0 / numBins; % the length of a bin in degrees (should be integer)
cellWidth = round(ROICols * 1.0 / gridDim(2) / 4);
cellHeight = round(ROIRows * 1.0 / gridDim(1) / 4);

% looping over the blocks (cells)
for i = 0:gridDim(1)-1 % grid rows (0-based indexing)
    for j = 0:gridDim(2)-1 % grid columns (0-based indexing)
        % looping horizontally and vertically per cell in the block
        block_descriptor = []; % the block descriptor
        for x = 0:1
            for y = 0:1
                h = zeros(1, numBins); % the histogram of gradients for the (y, x) cell in the block
                % looping over each pixel in the cell
                for r = 0:cellHeight -1
                    for c = 0:cellWidth -1
                        % obtaining pixel coordinates
                        p = i * (4*cellHeight) + upLeft(1) + (y*cellHeight) + r;
                        q = j * (4*cellWidth) + upLeft(2) + (x*cellWidth) + c;
                
                        % obtaining angle and norm at (p, q)
                        mag = normG(p, q); a = angle(p, q);
                
                        % finding the index of the bin to increase
                        binIndex = fix(a / bin_size) + 1;
                
                        % Interpolating: Practically "sharing" the vote between consecutive bins (cyclically) 
                        upperBound = binIndex * bin_size;
                        lowerBound = (binIndex - 1) * bin_size;
                
                        val1 = mag * (upperBound - a) / bin_size;
                        val2 = mag * (a - lowerBound) / bin_size;
                
                        if (binIndex == numBins) % casting the vote in the last and first
                            nextBinIndex = 1;
                        else
                            nextBinIndex = binIndex+1;
                        end
                        h(binIndex) = h(binIndex) + val1;
                        h(nextBinIndex) = h(nextBinIndex) + val2;
                    end
                end
            % augmenting the block descriptor the cell histogram
            block_descriptor = [block_descriptor, h];
            end
        end
        % normalizing the block descriptor
        block_descriptor=block_descriptor/sqrt(norm(block_descriptor)^2+e);
        % augmenting the feature vector
        D = [D, block_descriptor];
    end
end