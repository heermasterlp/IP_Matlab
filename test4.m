hu_files = '111.jpg';
hu_rgb = imread(hu_files);
hu_gray = rgb2gray(hu_rgb);
hu_bw = im2bw(hu_gray, 0.3);
hu_bw = ~hu_bw;

figure, imshow(hu_bw);
[L, nm] = bwlabel(hu_bw, 8);
stats = regionprops(L, 'BoundingBox', 'Centroid', 'Area');

fprintf('nm: %d \n', nm);

wind_w = 100;
wind_h = 100;

rt_list = {};
rt_cent_list = {};
for i = 1:nm
    rt = stats(i).BoundingBox;
    area = stats(i).Area;
    ct = stats(i).Centroid;
    if area < 100
        hu_bw(round(rt(2)):round(rt(2)+rt(4)), round(rt(1)):round(rt(1)+rt(3))) = 0;
        continue;
    end
    
    v = [rt(1), rt(2), rt(3), rt(4)];
    rt_list{end+1} = v;
    rt_cent_list{end+1} = [ct(1), ct(2)];
    showrt(v, 'g');
end

len = length(rt_list);
fprintf('len rt: %d \n', len);

T = 95;
rt_results = {};
rt_index = {};

for i = 1:len
    
    if ~isempty(find([rt_index{:}] == i))
        continue;
    end
    rta = rt_list{i};
    va = [rta(1) rta(2) rta(3) rta(4)];
    cta = [va(1)+va(3)/2 va(2)+va(4)/2];
    
    ax = [va(1) va(1)+va(3) va(1)+va(3) va(1) va(1)];
    ay = [va(2) va(2) va(2)+va(4) va(2)+va(4) va(2)];
    
    new_rt = va;
    
    for j = 1:len
        if j == i || ~isempty(find([rt_index{:}] == j))
            continue;
        end
        
        rtb = rt_list{j};
        vb = [rtb(1) rtb(2) rtb(3) rtb(4)];
        ctb = [vb(1)+vb(3)/2 vb(2)+vb(4)/2];
        
        bx = [vb(1) vb(1)+vb(3) vb(1)+vb(3) vb(1) vb(1)];
        by = [vb(2) vb(2) vb(2)+vb(4) vb(2)+vb(4) vb(2)];
        
        in1 = inpolygon(bx, by, ax, ay);
        in1 = in1(1:4);
        id1 = find(in1==1);
        
        in2 = inpolygon(ax, ay, bx, by);
        in2 = in2(1:4);
        id2 = find(in2==1);
        
        % b in a
        if length(id1) == 4
            rt_index{end+1} = j;
            continue;
        end
        
        % a in b
        if length(id2) == 4
            rt_index{end+1} = j;
            continue;
        end
        
        % Near by with border
        ct_new = [new_rt(1)+new_rt(3)/2 new_rt(2)+new_rt(4)/2];
        distance = sqrt((ct_new(1)-ctb(1))^2 + (ct_new(2) - ctb(2))^2);
        
        if distance < T
            new_x = min(new_rt(1), vb(1));
            new_y = min(new_rt(2), vb(2));
            new_w = max(new_rt(1)+new_rt(3), vb(1)+vb(3)) - new_x;
            new_h = max(new_rt(2)+new_rt(4), vb(2)+vb(4)) - new_y;
            
            new_rt = [new_x new_y new_w new_h];
            
            rt_index{end+1} = j;
        end
    end
    rt_results{end+1} = new_rt;
    rt_index{end+1} = i;
end

fprintf('len rt_results: %d \n', length(rt_results));

figure, imshow(hu_bw);
for i = 1:length(rt_results)
    v = rt_results{i};
    showrt(v, 'g');
end