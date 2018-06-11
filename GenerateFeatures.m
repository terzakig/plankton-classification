% This generates featur4e vectors from the TIFF images in a directory
% Choose a directory
dir_name = uigetdir
% 1. retrieving all files in the directory
files = dir(dir_name);

N = length(files); % number of files

% The global size for the surrounding rectangles of blobs
GlobalSize = [250, 350];
CellSize = [64, 64];   % cell size for the HOG (combined with the above GlobalSize of cropping rectangle we should have good translation invariance)
Descriptors = [];
for i = 1:N
    if (files(i).bytes>0) % file is an image (not a directory)
        fname = files(i).name;
        % obtain the image
        full_name = [dir_name, '\', fname];
        img = imread(full_name);
        
        % Get the 4 festures from the image
        Features = computeFeatureVectors(img, GlobalSize, CellSize); 
        
        % Store the descriptors
        Descriptors = [Descriptors; Features];
    end
end

% saving descriptors
descriptor_file_name = [dir_name, '.mat'];
save(descriptor_file_name, 'Descriptors');