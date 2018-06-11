% compute Hu moments of a binary or nont image
function H = computeHuMomentsVector(img)

% scaling the image in the range of [0, 1] (if its already binary, it will not change
img1 = scaleImageRange(double(img));

% Scale invariant moments
eta11 = eta(1, 1, img1); eta12 = eta(1, 2, img1);
eta20 = eta(2,0, img1); eta02 = eta(0, 2, img1);
eta21 = eta(2,1, img1); 
eta30 = eta(3,0, img1); 
eta03 = eta(0,3, img1);




% computing Hu moments

I1 = eta20 + eta02;

I2 = (eta20 - eta02)^2 + 4*eta11^2;

I3 = (eta30 - 3*eta12)^2 + (3*eta21 - eta03)^2;

I4 = (eta30 + eta12)^2 + (eta21 + eta03)^2;

I5 = (eta30 - 3*eta12)*(eta30 + eta12)*( (eta30 + eta12)^2 - 3*(eta21 + eta03)^2 ) + (3*eta21 - eta03)*(eta21 + eta03)*( 3*(eta30 + eta12)^2 - (eta21 + eta03)^2 );

I6 = (eta20 - eta02)*( (eta30 + eta12)^2 - (eta21 + eta03)^2 ) + 4*eta11*(eta30 + eta12)*(eta21 + eta03);

I7 = (3*eta21 - eta03)*(eta30 + eta12)*( (eta30 + eta12)^2 - 3*(eta21 + eta03)^2 ) - (eta30 - 3*eta12)*(eta21 + eta03)*( 3*(eta30 + eta12)^2 - (eta21 + eta03)^2 ); 

H = [I1, I2, I3, I4, I5, I6, I7];


end

% a local function for scale invariant  moments with the shortcut "eta"
function h = eta(i, j, img)
    h = computeScaleInvariantMoment(i, j, img);
end
