% com,pute a central moment
function mu = computeCentralMoment(i, j, A)
% INPUT
% i, j: order of the mmoment
% A: The image

% Output
% mu: The central moment

[rows, cols] = size(A);

% Obtaining M01, M10 and M00
M01 = computeMoment(0, 1, A);
M10 = computeMoment(1, 0, A);
M00 = computeMoment(0, 0, A);

Xhat = M10 / M00; Yhat = M01 / M00;

% and the central moment

X = repmat(0:cols-1, rows, 1) - Xhat;
Xi = X .^ i;
Y = repmat([0:rows-1]', 1, cols) - Yhat;
Yj = Y .^ j;

mu =  sum(sum(A .* (Xi .* Yj)));
