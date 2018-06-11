% mirror an image about the axis at column c0
function img = mirrorImageAboutY(c0, img)

[rows, cols] = size(img);
% for r = 1:rows
%     for c = 1:c0
%         index = c0 - c + c0;
%         if (index <= cols)
%             val = img(r, c);
%             img(r, c) = img(r, index);
%             img(r, index) = val;
%         end
%     end
T1 = [1 0 -c0; 0 1 0; 0 0 1];
T2 = [1 0 c0; 0 1 0; 0 0 1];
M = [-1 0 0 ; 0 1 0; 0 0 1];

A = T2*M*T1;

Atform = affine2d(A');

img = imwarp(img, Atform);
end
