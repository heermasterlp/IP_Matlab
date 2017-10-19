hu_files = '11.jpg';
hu_rgb = imread(hu_files);
hu_gray = rgb2gray(hu_rgb);
hu_bw = im2bw(hu_gray, 0.4);
hu_bw = ~hu_bw;

figure, imshow(hu_bw);
[L, nm] = bwlabel(hu_bw, 8);
stats = regionprops(L, 'BoundingBox', 'Centroid', 'Area');

fprintf('nm: %d \n', nm);

rt_list = {};
rt_cent_list = {};
for i = 1:nm
    rt = stats(i).BoundingBox;
    area = stats(i).Area;
    ct = stats(i).Centroid;
    if area < 100
        hu_bw(rt(2):rt(2)+rt(4), rt(1):rt(1)+rt(3)) = 0;
        continue;
    end
    
    v = [rt(1), rt(2), rt(3), rt(4)];
    rt_list{end+1} = v;
    rt_cent_list{end+1} = [ct(1), ct(2)];
    showrt(v, 'g');
end
len = length(rt_list);
fprintf('len rt: %d \n', len);

for i = 1:len
    rt = rt_list{i};
    hu_bw(rt(2):rt(2)+rt(4), rt(1):rt(1)+rt(3)) = 1;
end

figure, imshow(hu_bw);
[L, nm] = bwlabel(hu_bw, 8);
stats = regionprops(L, 'BoundingBox');
for i = 1:nm
    rt = stats(i).BoundingBox;
    v = [rt(1) rt(2) rt(3) rt(4)];
    hu_bw(rt(2):rt(2)+rt(4), rt(1):rt(1)+rt(3)) = 1;
    showrt(v, 'g');
end

figure, imshow(hu_bw);
[L, nm] = bwlabel(hu_bw, 8);
stats = regionprops(L, 'BoundingBox');
for i = 1:nm
    rt = stats(i).BoundingBox;
    v = [rt(1) rt(2) rt(3) rt(4)];
    hu_bw(rt(2):rt(2)+rt(4), rt(1):rt(1)+rt(3)) = 1;
    showrt(v, 'g');
end

figure, imshow(hu_bw);
[L, nm] = bwlabel(hu_bw, 8);
stats = regionprops(L, 'BoundingBox');
for i = 1:nm
    rt = stats(i).BoundingBox;
    v = [rt(1) rt(2) rt(3) rt(4)];
    hu_bw(rt(2):rt(2)+rt(4), rt(1):rt(1)+rt(3)) = 1;
    showrt(v, 'g');
end

figure, imshow(hu_bw);
[L, nm] = bwlabel(hu_bw, 8);
stats = regionprops(L, 'BoundingBox');
for i = 1:nm
    rt = stats(i).BoundingBox;
    v = [rt(1) rt(2) rt(3) rt(4)];
    hu_bw(rt(2):rt(2)+rt(4), rt(1):rt(1)+rt(3)) = 1;
    showrt(v, 'g');
end

figure, imshow(hu_bw);
[L, nm] = bwlabel(hu_bw, 8);
stats = regionprops(L, 'BoundingBox');
for i = 1:nm
    rt = stats(i).BoundingBox;
    v = [rt(1) rt(2) rt(3) rt(4)];
    hu_bw(rt(2):rt(2)+rt(4), rt(1):rt(1)+rt(3)) = 1;
    showrt(v, 'g');
end

figure, imshow(hu_bw);
[L, nm] = bwlabel(hu_bw, 8);
stats = regionprops(L, 'BoundingBox');
for i = 1:nm
    rt = stats(i).BoundingBox;
    v = [rt(1) rt(2) rt(3) rt(4)];
    hu_bw(rt(2):rt(2)+rt(4), rt(1):rt(1)+rt(3)) = 1;
    showrt(v, 'g');
end

figure, imshow(hu_bw);
[L, nm] = bwlabel(hu_bw, 8);
stats = regionprops(L, 'BoundingBox');
for i = 1:nm
    rt = stats(i).BoundingBox;
    v = [rt(1) rt(2) rt(3) rt(4)];
    hu_bw(rt(2):rt(2)+rt(4), rt(1):rt(1)+rt(3)) = 1;
    showrt(v, 'g');
end

figure, imshow(hu_bw);
[L, nm] = bwlabel(hu_bw, 8);
stats = regionprops(L, 'BoundingBox');
for i = 1:nm
    rt = stats(i).BoundingBox;
    v = [rt(1) rt(2) rt(3) rt(4)];
    hu_bw(rt(2):rt(2)+rt(4), rt(1):rt(1)+rt(3)) = 1;
    showrt(v, 'g');
end

figure, imshow(hu_bw);
[L, nm] = bwlabel(hu_bw, 8);
stats = regionprops(L, 'BoundingBox');
for i = 1:nm
    rt = stats(i).BoundingBox;
    v = [rt(1) rt(2) rt(3) rt(4)];
    hu_bw(rt(2):rt(2)+rt(4), rt(1):rt(1)+rt(3)) = 1;
    showrt(v, 'g');
end

figure, imshow(hu_bw);
[L, nm] = bwlabel(hu_bw, 8);
stats = regionprops(L, 'BoundingBox');
for i = 1:nm
    rt = stats(i).BoundingBox;
    v = [rt(1) rt(2) rt(3) rt(4)];
    hu_bw(rt(2):rt(2)+rt(4), rt(1):rt(1)+rt(3)) = 1;
    showrt(v, 'g');
end

figure, imshow(hu_bw);
[L, nm] = bwlabel(hu_bw, 8);
stats = regionprops(L, 'BoundingBox', 'Centroid');
for i = 1:nm
    rt = stats(i).BoundingBox;
    v = [rt(1) rt(2) rt(3) rt(4)];
    hu_bw(rt(2):rt(2)+rt(4), rt(1):rt(1)+rt(3)) = 1;
    showrt(v, 'g');
end

fprintf('nm len: %d \n', nm);
% Remove joint rectangles
for i = 1:nm
    rta = stats(i).BoundingBox;
    cta = stats(i).Centroid;
    for j = i+1:nm
        
        rtb = stats(j).BoundingBox;
        ctb = stats(j).Centroid;
    end
end



fprintf('End \n');

