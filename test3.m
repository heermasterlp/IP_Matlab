hu_files = '11.jpg';
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

rt_w = 0;
rt_h = 0;
for i = 1:len
    rt = rt_list{i};
    rt_w = rt_w + rt(3);
    rt_h = rt_h + rt(4);
end
rt_w = round(rt_w / len);
rt_h = round(rt_h / len);

wind_w = rt_w;
wind_h = rt_h;
v = [0 0 wind_w wind_h];
showrt(v, 'r');

rt_index_used = {};
rt_results = {};
for i = 1:len
    rta = rt_list{i};
    wind_rt = [rta(1) rta(2) wind_w wind_h];
    new_rt = rta;
    
    wind_rtx = [wind_rt(1), wind_rt(1)+wind_rt(3), wind_rt(1)+wind_rt(3), wind_rt(1), wind_rt(1)];
    wind_rty = [wind_rt(2), wind_rt(2), wind_rt(2)+wind_rt(4), wind_rt(2)+wind_rt(4), wind_rt(2)];
    
    for j = 1:len
        if i == j
            continue;
        end
        
        rtb = rt_list{j};
        vb = [rtb(1) rtb(2) rtb(3) rtb(4)];
        bx = [vb(1), vb(1)+vb(3), vb(1)+vb(3), vb(1), vb(1)];
        by = [vb(2), vb(2), vb(2)+vb(4), vb(2)+vb(4), vb(2)];
        
        in = inpolygon(bx, by, ax, ay);
        in = in(1:4);
        id = find(in==1);
        
        if ~isempty(id)
            % Contain or joint
            
        else
            % Disjoint
        end
        
    end
end



