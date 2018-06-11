% compute the moment of a gray image
function m = computeMoment(i, j, A)
% OUTPUT
% m: the moment

% i, j: the order in the x amd y axis respectively
% A: the image


[rows, cols] = size(A);
X = repmat(0:cols-1, rows, 1);
Xi = X .^ i;
Y = repmat([0:rows-1]', 1, cols);
Yj = Y .^ j;

m =  sum(sum(A .* (Xi .* Yj)));