hu_files = '11.jpg';

hu_rgb = imread(hu_files);

hu_gray = rgb2gray(hu_rgb);


hu_bw = im2bw(hu_gray, 0.4);

hu_bw = ~hu_bw;
figure, imshow(hu_bw);
[L, nm] = bwlabel(hu_bw, 8);
stats = regionprops(L, 'BoundingBox', 'Area');

fprintf('nm: %d \n', nm);

for i = 1:nm
    rt = stats(i).BoundingBox;
    area = stats(i).Area;
    if area < 100
        continue;
    end
    v = [rt(1), rt(2), rt(3), rt(4)];
    showrt(v, 'g');
end

% Merge rectangles.
figure, imshow(hu_bw);
for i = 1:nm
    rt_a = stats(i).BoundingBox;
    rt_av = [rt_a(1), rt_a(2), rt_a(3), rt_a(4)];
    
    rt_a_x = [rt_av(1), rt_av(1)+rt_av(3), rt_av(1)+rt_av(3), rt_av(1), rt_av(1)];
    rt_a_y = [rt_av(2), rt_av(2), rt_av(2)+rt_av(4), rt_av(2)+rt_av(4), rt_av(2)];
    
    for j = (i+1):nm
        rt_b = stats(j).BoundingBox;
        rt_bv = [rt_b(1), rt_b(2), rt_b(3), rt_b(4)];
    
        rt_b_x = [rt_bv(1), rt_bv(1)+rt_bv(3), rt_bv(1)+rt_bv(3), rt_bv(1), rt_bv(1)];
        rt_b_y = [rt_bv(2), rt_bv(2), rt_bv(2)+rt_bv(4), rt_bv(2)+rt_bv(4), rt_bv(2)];
        
        in1 = inpolygon(rt_a_x, rt_a_y, rt_b_x, rt_b_y);
        in1 = in1(1:4);
        id1 = find(in1 == 1);
        in2 = inpolygon(rt_b_x, rt_b_y, rt_a_x, rt_a_y);
        in2 = in1(1:4);
        id2 = find(in2 == 1);
        if length(id1) ~= length(id2)
            fprintf('id1: %d id2: %d \n', length(id1), length(id2));
        end
        
        if length(id1) ~= 4 && length(id1) ~= 2 && length(id1) ~= 1 && length(id1) ~= 0
            fprintf('id1: %d id2: %d \n', length(id1), length(id2));
        end
        
        % contain
        if length(id1) == 4
        end
        
        % intersect
        if length(id1) == 2 || length(id1) == 1 || length(id1) == 4
            [c,rt,lx,ly,rx,ry,x0,y0] = Merge(rt_av,rt_bv);
            showrt(rt, 'b');
        end
        
        % disjoint
        if length(id1) == 0
        end
    end
end

fprintf('End \n');

