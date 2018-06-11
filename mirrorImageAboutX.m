% mirror an image about the axis at row r0
function img = mirrorImageAboutX(r0, img)


T1 = [1 0 0; 0 1 -r0; 0 0 1];
M = [1 0 0; 0 -1 0; 0 0 1];
T2 = [1 0 0; 0 1 r0; 0 0 1];

A = T2 * M * T1;
Atform = affine2d(A');
img = imwarp(img, Atform);
% [rows, cols] = size(img);
% for c = 1:cols
%     for r = 1:r0
%         index = r0 - r + r0;
%         if (index <= rows)
%             val = img(r, c);
%             img(r, c) = img(index, c);
%             img(index, c) = val;
%         end
%     end
end
