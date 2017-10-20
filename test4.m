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

T = 70;
rt_results = {};
rt_index = {};

for i = 1:len
    rta = rt_list{i};
    va = [rta(1) rta(2) rta(3) rta(4)];
    cta = [va(1)+va(3)/2 va(2)+va(4)/2];
    
    new_rt = va;
    
    for j = 1:len
        if j == i
            continue;
        end
        rtb = rt_list{j};
        vb = [rtb(1) rtb(2) rtb(3) rtb(4)];
        ctb = [vb(1)+vb(3)/2 vb(2)+vb(4)/2];
        
        distance = sqrt((cta(1)-ctb(1))^2 + (cta(2) - ctb(2))^2);
        
        if distance < T
            new_x = min(new_rt(1), vb(1));
            new_y = min(new_rt(2), vb(2));
            new_w = max(new_rt(1)+new_rt(3), vb(1)+vb(3)) - new_x;
            new_h = max(new_rt(2)+new_rt(4), vb(2)+vb(4)) - new_y;
            
            new_rt = [new_x new_y new_w new_h];
        end
        
    end
    rt_results{end+1} = new_rt;
end

figure, imshow(hu_bw);
for i = 1:length(rt_results)
    v = rt_results{i};
    showrt(v, 'g');
end

% 
% 
% rt_w = 0;
% rt_h = 0;
% for i = 1:len
%     rt = rt_list{i};
%     rt_w = rt_w + rt(3);
%     rt_h = rt_h + rt(4);
% end
% rt_w = round(rt_w / len);
% rt_h = round(rt_h / len);
% 
% wind_w = rt_w;
% wind_h = rt_h;
% v = [0 0 wind_w wind_h];
% showrt(v, 'r');
% 
% rt_index_used = {};
% rt_results = {};
% for i = 1:len
%     rta = rt_list{i};
%     va = [rta(1) rta(2) rta(3) rta(4)];
%     ax = [va(1), va(1)+va(3), va(1)+va(3), va(1), va(1)];
%     ay = [va(2), va(2), va(2)+va(4), va(2)+va(4), va(2)];
%     
%     new_rt = va;
%     for j = 1:len
%         if i == j
%             continue;
%         end
%         
%         rtb = rt_list{j};
%         
%         vb = [rtb(1) rtb(2) rtb(3) rtb(4)];
%         bx = [vb(1), vb(1)+vb(3), vb(1)+vb(3), vb(1), vb(1)];
%         by = [vb(2), vb(2), vb(2)+vb(4), vb(2)+vb(4), vb(2)];
%         
%         in1 = inpolygon(bx, by, ax, ay);
%         in1 = in1(1:4);
%         id1 = find(in1==1);
%         
%         in2 = inpolygon(ax,ay,bx,by);
%         in2 = in2(1:4);
%         id2 = find(in2==1);
%         
%         if isempty(id1) && isempty(id2)
%             % id1 and id2 =0, disjoint
%         elseif length(id1) == 4
%             % b inside a, and length(id2)=0
%         elseif length(id2) == 4
%             % a inside b, and length(id1)=0
%             va = vb;
%             ax = [va(1), va(1)+va(3), va(1)+va(3), va(1), va(1)];
%             ay = [va(2), va(2), va(2)+va(4), va(2)+va(4), va(2)];
%         else
%             % a and b one in each other.
%             % Contain or joint
%             new_x = min(va(1), vb(1));
%             new_y = min(va(2), vb(2));
%             new_w = max(va(1)+va(3), vb(1)+vb(3)) - new_x;
%             new_h = max(va(2)+va(4), vb(2)+vb(4)) - new_y;
%             
%             new_rt = [new_x new_y new_w new_h];
%             
%             va = new_rt;
%             ax = [va(1), va(1)+va(3), va(1)+va(3), va(1), va(1)];
%             ay = [va(2), va(2), va(2)+va(4), va(2)+va(4), va(2)];
%             j = j-1;
%         end
%     end
%     rt_results{end+1} = va;
% end
% 
% figure, imshow(hu_bw);
% for i = 1:length(rt_results)
%     v = rt_results{i};
%     showrt(v, 'r');
% end
% 
% 
% % calculate the distance 
% rt_seperate = {};
% T = 85;
% len = length(rt_results);
% for i = 1:len
%      rta = rt_results{i};
%      va = [rta(1) rta(2) rta(3) rta(4)];
%      cta = [va(1)+va(3)/2 va(2)+va(4)/2];
%      
%      new_rt = va;
%      for j = 1:len
%          if i == j
%              continue;
%          end
%          rtb = rt_results{j};
%          vb = [rtb(1) rtb(2) rtb(3) rtb(4)];
%          ctb = [vb(1)+vb(3)/2 vb(2)+vb(4)/2];
%          
%          distance = sqrt((cta(1)-ctb(1))^2 + (cta(2) - ctb(2))^2);
%          
%          if distance < T
%              new_x = min(new_rt(1), vb(1));
%              new_y = min(new_rt(2), vb(2));
%              new_w = max(new_rt(1)+new_rt(3), vb(1)+vb(3)) - new_x;
%              new_h = max(new_rt(2)+new_rt(4), vb(2)+vb(4)) - new_y;
%             
%              new_rt = [new_x new_y new_w new_h];
%          end
%      end
%      rt_seperate{end+1} = new_rt;
% end
% 
% figure, imshow(hu_bw);
% for i = 1:length(rt_seperate)
%     v = rt_seperate{i};
%     showrt(v, 'r');
% end