% The function that generates a feature vector
function Features = computeFeatureVectors(img, GlobalSize, CellSize)
% INPUT
% img: the image in the range 0-65535 (tif)
% GlobalSize: The standard rectangle size for HOG generation (deafault should be 250 x 350)
% CellSize: The size of a cell for the HOG descriptor (64x64 is highly recommended)

% OUTPUT
% Features: A 4xN array of features (a feature for each reflection about one of the two axes of the blob)

% converting the image to 0-255 range
img1 = uint8(double(img)*255 / 65535);
        
% DO SOME PRE-PROCESSING HERE (smoothing, etc.)

kernel = fspecial('gaussian', [1, 5], 2); % horizontal kernel in order to get rid of the vertical high frequency components
img1 = imfilter(img1, kernel);

% PRE-PROCESSING DONE
        
% doing blob analysis
[I,  minRow, maxRow, minCol, maxCol, centroid, u1, u2, s1, s2] =  blobAnalysis(img1);

% Blob analysis returns four images in thelist I. Need to create four
% distinct feature vector vectors

Features = [];
for i = 1:4
    % cropping the rectangle of interest
    Img = I(minRow:maxRow, minCol:maxCol, i);
    % obtaining the two rotation/scale/translation invariant (Hu) moment
    % descriptors for Blob and for the image
    hd1 = computeHuMomentsVector(Img>0); % Blob first
    hd2 = computeHuMomentsVector(Img);   % Image is second
    
    
    % resizing to global size
    Img = imresize(Img, GlobalSize); % Bicubic interpolation used (which is good by me...)
    
    % Now we compute the HOG feature vector (2x2 Block size and overlapping
    % in the middle). Also, 9 bin hostogram
    [hogvec, visualization] = extractHOGFeatures(double(Img),'CellSize',CellSize);
    
    % visualise if u like...
    subplot(1,2,1);imshow(Img); subplot(1,2,2); plot(visualization);
    pause(0.01);
    % And the descriptor is...
    Features = [Features; [hd1, hd2, hogvec]];
end