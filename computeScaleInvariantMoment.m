% compute the i-j scale invariant moment
function eta = computeScaleInvariantMoment(i, j, A)
% INPUT
% i, j: The order of the moment
% A: the image

%OUTPUT
% eta: The moment

% computing the central moments required
muij = computeCentralMoment(i, j, A);
mu00 = computeCentralMoment(0,0, A);

eta = muij / mu00 ^ (1+(i+j)/2);
