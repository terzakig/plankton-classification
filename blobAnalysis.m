% function rotate and translate image in order to aligbn the blob's principal axis with the x-axis

function [Imgs, minRow, maxRow, minCol, maxCol, centroid, u1, u2, s1, s2] = blobAnalysis(img)
% INPUT
% img: The grayscale image
% OUTPUT
% A: The transformation that aligns the blob's principal axis with the x-axis
% centroid: [x,y] coordinates of the centroid of the blob
% u1, u2: The blob's axes unit directions
% s1, s2: The respctive singular values of the covariance matrix corresponding to the blob's surrounding ellipse
% minCol, maxCol, minRow, maxzRow: maximum and minimum coordinartes of the blob's surrounding rectangle


% Autothresholding
[timg, threshold] = autoThreshold(img);
[rows, cols] = size(timg);
% dilation and erosion
SE = strel('square',3); % a square structuring element
I = imdilate(timg, SE); % dilating
I = imerode(I, SE);     % erosion
%I = timg;

Blob = I;

% listing all non-zero point coordinates
Index = find(I>0);
x = 1:cols;
y = 1:rows;
[X, Y] = meshgrid(x, y);
% the data matrix...
B = [Y(Index), X(Index)];


% And the mean is,
centroid = mean(B,1);

% and the centralized data,
D = B - repmat(centroid, size(B,1), 1);

% SVD of the covaraince matrix of the data
[U,S,V] = svd(D'*D);

% It follows that U = V and the first two rows are the axes of the
% ellipsoid
u1 = U(1,:)'; u2 = U(2, :)';
s1 = S(1,1); s2 = S(2,2); % the length of the axes

% The transformation that aligns the principal axis of the image with the x-axis
T1 = [eye(3,2) [-centroid';1]];
R = [[u1;0], [u2;0], [0; 0; 1]]; % the rotation that presumably rotated the blob about its centroid

T2 = [eye(3,2) [centroid';1]];

% the overall transformation
A = T2 * R * T1;

Atform = affine2d(A');

% apply the transformation to both the image and the blob
Img = imwarp(img, Atform);
Blob = imwarp(Blob, Atform);
Blob = Blob > 0;

% obtaining minCol, maxCol, maxRow, minRow
Index = find(Blob>0);
[rows, cols] = size(Blob);
x = 1:cols;
y = 1:rows;
[X, Y] = meshgrid(x, y);
minCol = min(X(Index)); maxCol = max(X(Index));
minRow = min(Y(Index)); maxRow = max(Y(Index));

% There is a chance that the principal axis was "misread", so we now check
% the encasing rectangle and if the blob is longer on the y-axis, we rotate
% by 90 degrees to correct things
if (maxRow-minRow > maxCol - minCol) % we need to rotate the blob
    A1 = T2 * [cos(pi/2) -sin(pi/2) 0; sin(pi/2) cos(pi/2) 0; 0 0 1] * T1;
    A1tform = affine2d(A1');
    % apply the transformation once again to the transfomred image and blob
    Img = imwarp(Img, A1tform);
    Blob = imwarp(Blob, A1tform);
    Blob = Blob > 0;
    
    % must also change the encasing rectangle coordinates
    temp = minCol;
    minCol = minRow; minRow = temp;
    temp = maxCol;
    maxCol = maxRow; maxRow = temp;
    
end



Img = uint8(double(Img) .* Blob);

% obtaining the four possible mirrored images
Imgs(:,:,1) = Img;
r0 = round(centroid(2));
c0 = round(centroid(1));
t = 1;
for i = 0:1
    for j = 0:1
        Imgs(:,:,t) = Img;
        if (i == 1) % mirroring the image about the centroid axis
        Imgs(:,:,t) = mirrorImageAboutX(r0, Imgs(:,:,t));
        end
        
        if (j == 1) % mirroring the image about the centroid axis
            Imgs(:,:,t) = mirrorImageAboutY(c0, Imgs(:,:,t));        
        end
        
        t = t+1;    
    end
end
   
                
