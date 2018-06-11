
% Train an SVM for a plankton Species vs All
N = 200; % positive samples (training set)
M = 40; % negative samples per species

% open the file
[filename, path] = uigetfile('*.mat', 'Select positive species descriptor file');

% load the file
load([path, filename], 'Descriptors');

numPositiveDescriptors = min(N, size(Descriptors, 1));
PositiveDescriptors = Descriptors(1:numPositiveDescriptors, :);
clear Descriptors;

% Now selecting multiple species files in order to obtain the 'false' descriptros
[filenames, path] = uigetfile('*.mat', 'Select negative species descriptor file(s)', 'MultiSelect', 'on');

% constructing a list of descriptors by opening each species file separately
numNegativeFiles = length(filenames);

NegativeDescriptors = [];
for i = 1:numNegativeFiles
    % load the file
    fstr = [path, filenames{i}];
    load(fstr , 'Descriptors');
    m = size(Descriptors, 1);
    k = min(m, M); % using as many negative descriptors as possible
    NegativeDescriptors = [NegativeDescriptors; Descriptors(1:k, :)];
        
    % clearing the temo variable
    clear Descriptors;

end

numNegativeDescriptors = size(NegativeDescriptors, 1);

%%%%%%%%%% SVM Training %%%%%%%%%%%%%%

% obtaining the name of the species by spliting the filename
[p, species, ext] = fileparts(filename);

data = [PositiveDescriptors; NegativeDescriptors];
labels = [repmat(1, numPositiveDescriptors, 1); repmat(0, numNegativeDescriptors, 1)];

% train the SVM
svm = svmtrain(data, labels, 'kernel_function', 'quadratic');
%svm = svmtrain(data, labels);


% save the svm
save([species, '_svm', ext], 'svm');