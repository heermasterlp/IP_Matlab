in = './ke/grayscale.png';
src_img = imread(in);

% figure; imshow(src_img);

% Pre-process
gray_img = rgb2gray(src_img);
figure; imshow(gray_img);

% Gray scale
gray_img = gscale(gray_img);
figure; imshow(gray_img);

% Add rectangles
gray_img = ~gray_img;
[L, nm] = bwlabel(gray_img, 8);
stats = regionprops(L, 'BoundingBox', 'Centroid', 'Area');

fprintf('stats len: %d \n', length(stats));
for i = 1:nm
    v = stats(i).BoundingBox;
    showrt(v, 'g');
end

% merge rectangles
MAX_DIST = 100;

bboxes = vertcat(stats.BoundingBox);

disp(size(gray_img, 2));

% Convert from the [x y width height] bounding box format to the [xmin ymin
% xmax ymax] format for convenience.
xmin = bboxes(:,1);
ymin = bboxes(:,2);
xmax = xmin + bboxes(:,3) - 1;
ymax = ymin + bboxes(:,4) - 1;

% Clip the bounding boxes to be within the image bounds
xmin = max(xmin, 1);
ymin = max(ymin, 1);
xmax = min(xmax, size(I,2));
ymax = min(ymax, size(I,1));

% Show the expanded bounding boxes
expandedBBoxes = [xmin ymin xmax-xmin+1 ymax-ymin+1];

% Compute the overlap ratio
overlapRatio = bboxOverlapRatio(expandedBBoxes, expandedBBoxes);
disp(overlapRatio);

% Set the overlap ratio between a bounding box and itself to zero to
% simplify the graph representation.
n = size(overlapRatio,1);
overlapRatio(1:n+1:n^2) = 0;

% Create the graph
g = graph(overlapRatio);

% Find the connected text regions within the graph
componentIndices = conncomp(g);

% Merge the boxes based on the minimum and maximum dimensions.
xmin = accumarray(componentIndices', xmin, [], @min);
ymin = accumarray(componentIndices', ymin, [], @min);
xmax = accumarray(componentIndices', xmax, [], @max);
ymax = accumarray(componentIndices', ymax, [], @max);

% Compose the merged bounding boxes using the [x y width height] format.
textBBoxes = [xmin ymin xmax-xmin+1 ymax-ymin+1];

% Remove bounding boxes that only contain one text region
numRegionsInGroup = histcounts(componentIndices);
textBBoxes(numRegionsInGroup == 1, :) = [];

% Show the final text detection result.
ITextRegion = insertShape(src_img, 'Rectangle', textBBoxes,'LineWidth',1, 'Color', 'g');

figure; imshow(ITextRegion);

disp(size(textBBoxes));

max_size = 0.0;
min_size = 1000.0;
for i = 1: size(textBBoxes, 1)
    max_size = max(max_size, max(textBBoxes(i, 3:4)));
    min_size = min(min_size, min(textBBoxes(i, 3:4)));
end

disp(max_size);
disp(min_size);

new_width = floor(max_size + min_size / 5);
disp(new_width);

% Divide two images

for i = 1: size(textBBoxes, 1)
    rt = textBBoxes(i, :);
    
    new_square = ~zeros(new_width, new_width, 'uint8');
end
