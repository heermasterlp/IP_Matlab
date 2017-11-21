in = './ke/grayscale.png';
src_img = imread(in);

gray_img = rgb2gray(src_img);

% Add rectangles
gray_img = ~gray_img;
[L, nm] = bwlabel(gray_img, 8);
stats = regionprops(L, 'BoundingBox', 'Centroid', 'Area');

fprintf('stats len: %d \n', length(stats));

% merge rectangles
bboxes = vertcat(stats.BoundingBox);

% Convert from the [x y width height] bounding box format to the [xmin ymin
% xmax ymax] format for convenience.
xmin = bboxes(:,1);
ymin = bboxes(:,2);
xmax = xmin + bboxes(:,3) - 1;
ymax = ymin + bboxes(:,4) - 1;

% Clip the bounding boxes to be within the image bounds
xmin = max(xmin, 1);
ymin = max(ymin, 1);
xmax = min(xmax, size(gray_img,2));
ymax = min(ymax, size(gray_img,1));

% Show the expanded bounding boxes
expandedBBoxes = [xmin ymin xmax-xmin+1 ymax-ymin+1];

% Compute the overlap ratio
overlapRatio = bboxOverlapRatio(expandedBBoxes, expandedBBoxes);

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

max_size = 0.0;
min_size = 1000.0;
for i = 1: size(textBBoxes, 1)
    max_size = max(max_size, max(textBBoxes(i, 3:4)));
    min_size = min(min_size, min(textBBoxes(i, 3:4)));
end

% radio of Height / Width
for i = 1: size(textBBoxes, 1)
    
    radio_w_h = textBBoxes(i, 3) / textBBoxes(i, 4);
    fprintf('radio of %f / %f =  %f \n', textBBoxes(i, 3), textBBoxes(i, 4), radio_w_h);
end

new_width = floor(max_size + min_size / 5);

% Divide two images
char_list = {};
for i = 1: size(textBBoxes, 1)
    rt = textBBoxes(i, :);
    rt_x0 = rt(1);
    rt_y0 = rt(2);
    rt_x1 = rt(1) + rt(3);
    rt_y1 = rt(2) + rt(4);
    
    src_square = ~gray_img(rt_y0:rt_y1, rt_x0:rt_x1);
    
    src_ct = [floor(size(src_square, 1)) floor(size(src_square, 2))];
    
    dst_square = ~zeros(new_width, new_width, 'uint8');
    
    dst_ct = [floor(size(dst_square, 1)) floor(size(dst_square, 2))];
    
    offset = dst_ct - src_ct;
    offset = floor(offset / 2);
    
    for y = 1: size(src_square, 1)
        for x = 1: size(src_square, 2)
            dst_square(y+offset(1), x+offset(2)) = src_square(y, x)*255;
        end
    end
    char_list{end+1} = dst_square;
 
    filename = sprintf('test%d.png', i);

    imwrite(dst_square, filename);
end

fprintf('char list len: %d \n', length(char_list));

% Center of grivaty 
for i = 1: length(char_list)
    char_img = cell2mat(char_list(i));
    char_img = ~char_img;
    
    goc_x = 0;
    goc_y = 0;
    row_sum = 0;
    index_sum = 0;
    for j = 1: size(char_img, 1)
        row_sum = row_sum + sum(char_img(j, :)) * j;
        if sum(char_img(j, :)) > 0
            index_sum = index_sum + j;
        end
    end
    goc_y = floor(row_sum / index_sum);
    
    col_sum = 0;
    index_sum = 0;
    for j = 1: size(char_img, 2)
        col_sum = col_sum + sum(char_img(:, j) * j);
        index_sum = index_sum + j;
    end
    goc_x = floor(col_sum / index_sum);
    
    fprintf('goc x: %d \n', goc_x);
    fprintf('goc y: %d \n', goc_y);
    
    cen = [goc_y goc_x];
    char_img = ~char_img;
    figure; imshow(char_img);
    hold on
    plot(goc_x, goc_y, 'go');
end



% for i = 1: length(char_list)
%     disp(char_list(i));
%     char_img = cell2mat(char_list(i));
%     
%     char_img = ~char_img;
%     [L, nm] = bwlabel(char_img, 8);
%     sts = regionprops(L, 'BoundingBox');
%     fprintf('stats len: %d \n', length(sts));
%     
%     bboxes = vertcat(stats.BoundingBox);
%     xmin = bboxes(:,1);
%     ymin = bboxes(:,2);
%     xmax = xmin + bboxes(:,3) - 1;
%     ymax = ymin + bboxes(:,4) - 1;
%     xmin = max(xmin, 1);
%     ymin = max(ymin, 1);
%     xmax = min(xmax, size(gray_img,2));
%     ymax = min(ymax, size(gray_img,1));
%     
%     expandedBBoxes = [xmin ymin xmax-xmin+1 ymax-ymin+1];
%     overlapRatio = bboxOverlapRatio(expandedBBoxes, expandedBBoxes);
%     n = size(overlapRatio,1);
%     overlapRatio(1:n+1:n^2) = 0;
%     g = graph(overlapRatio);
% 
%     componentIndices = conncomp(g);
%     
%     xmin = accumarray(componentIndices', xmin, [], @min);
%     ymin = accumarray(componentIndices', ymin, [], @min);
%     xmax = accumarray(componentIndices', xmax, [], @max);
%     ymax = accumarray(componentIndices', ymax, [], @max);
%     
%     textBBoxes = [xmin ymin xmax-xmin+1 ymax-ymin+1];
%     numRegionsInGroup = histcounts(componentIndices);
%     textBBoxes(numRegionsInGroup == 1, :) = [];
%     
%     char_img = ~char_img;
%     ITextRegion = insertShape(char_img*255, 'Rectangle', textBBoxes,'LineWidth',1, 'Color', 'g');
%     figure; imshow(ITextRegion);
% 
% end