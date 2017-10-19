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

% Remove contain rectangles
rt_nocontain = {};
rt_rm_index = {};
for i = 1:len
    rta = rt_list{i};
    
    va = [rta(1) rta(2) rta(3) rta(4)];
    ax = [va(1), va(1)+va(3), va(1)+va(3), va(1), va(1)];
    ay = [va(2), va(2), va(2)+va(4), va(2)+va(4), va(2)];
    
    for j = i+1:len
        rtb = rt_list{j};
        
        vb = [rtb(1) rtb(2) rtb(3) rtb(4)];
        bx = [vb(1), vb(1)+vb(3), vb(1)+vb(3), vb(1), vb(1)];
        by = [vb(2), vb(2), vb(2)+vb(4), vb(2)+vb(4), vb(2)];
        
        in = inpolygon(bx,by,ax,ay);
        in = in(1:4);
        id = find(in == 1);
        
        if length(id) == 4
            % contain
            new_x = min(va(1), vb(1));
            new_y = min(va(2), vb(2));
            new_w = max(va(1)+va(3), vb(1)+vb(3)) - new_x;
            new_h = max(va(2)+va(4), vb(2)+vb(4)) - new_y;
            new_rt = [new_x new_y new_w new_h];
            
            rt_rm_index{end+1} = i;
            rt_rm_index{end+1} = j;
            
            rt_nocontain{end+1} = new_rt;
        end
    end
end
figure, imshow(hu_bw);
fprintf('rt_nocontain: %d \n', length(rt_nocontain));
for i = 1:length(rt_nocontain)
    v = rt_nocontain{i};
    showrt(v, 'g');
end

figure, imshow(hu_bw);
for i = 1:len
    id = find([rt_rm_index{:}] == i);
    if isempty(id)
        rt_nocontain{end+1} = rt_list{i};
    end
end
for i = 1:length(rt_nocontain)
    v = rt_nocontain{i};
    showrt(v, 'g');
end
 
% Remove the joint rectangles.
rt_nojoint = {};
rt_rmid_nojoint = {};
len = length(rt_nocontain);
fprintf('rt nocontain len: %d \n', len);

for i = 1:len
    
    id = find([rt_rmid_nojoint{:}] == i);
    if ~isempty(id)
        continue;
    end
    
    rta = rt_nocontain{i};
    
    va = [rta(1) rta(2) rta(3) rta(4)];
    ax = [va(1), va(1)+va(3), va(1)+va(3), va(1), va(1)];
    ay = [va(2), va(2), va(2)+va(4), va(2)+va(4), va(2)];
    
    for j = 1:len
        rtb = rt_nocontain{j};
     
        vb = [rtb(1) rtb(2) rtb(3) rtb(4)];
        bx = [vb(1), vb(1)+vb(3), vb(1)+vb(3), vb(1), vb(1)];
        by = [vb(2), vb(2), vb(2)+vb(4), vb(2)+vb(4), vb(2)];
        
        in = inpolygon(bx,by,ax,ay);
        in = in(1:4);
        id = find(in == 1);
        if ~isempty(id)
            % joint
            new_x = min(va(1), vb(1));
            new_y = min(va(2), vb(2));
            new_w = max(va(1)+va(3), vb(1)+vb(3)) - new_x;
            new_h = max(va(2)+va(4), vb(2)+vb(4)) - new_y;
            new_rt = [new_x new_y new_w new_h];
            
            va = new_rt;
            ax = [va(1), va(1)+va(3), va(1)+va(3), va(1), va(1)];
            ay = [va(2), va(2), va(2)+va(4), va(2)+va(4), va(2)];
            
            rt_rmid_nojoint{end+1} = j;
        end
    end
    rt_nojoint{end+1} = va;
end

figure, imshow(hu_bw);
for i = 1:length(rt_nojoint)
    v = rt_nojoint{i};
    showrt(v, 'g');
end




% rt_result = {};
% rt_index = {};
% for i = 1:len
%     
%     id_ = find([rt_index{:}] == i);
%      
%     if ~isempty(id_)
%          % the rectangle has been processed
%         continue;
%     end
%     
%     rta = rt_list{i};
%     cta = rt_cent_list{i};
%     
%     va = [rta(1) rta(2) rta(3) rta(4)];
%     ax = [va(1), va(1)+va(3), va(1)+va(3), va(1), va(1)];
%     ay = [va(2), va(2), va(2)+va(4), va(2)+va(4), va(2)];
%     
%     for j = i+1:len
%         
%         rtb = rt_list{j};
%         ctb = rt_cent_list{j};
%         
%         vb = [rtb(1) rtb(2) rtb(3) rtb(4)];
%         bx = [vb(1), vb(1)+vb(3), vb(1)+vb(3), vb(1), vb(1)];
%         by = [vb(2), vb(2), vb(2)+vb(4), vb(2)+vb(4), vb(2)];
%         
%         in = inpolygon(ax,ay,bx,by);
%         in = in(1:4);
%         id = find(in == 1);
%         
%         if isempty(id)
%             % disjoint
% %             fprintf('len id_: %d \n', length(id));
%         else
%             % not disjoint
%             fprintf('len id: %d \n', length(id));
%             
%             new_x = min(va(1), vb(1));
%             new_y = min(va(2), vb(2));
%             new_w = max(va(1)+va(3), vb(1)+vb(3)) - new_x;
%             new_h = max(va(2)+va(4), vb(2)+vb(4)) - new_y;
%             
%             
%             va = [new_x new_y new_w new_h];
%             ax = [va(1), va(1)+va(3), va(1)+va(3), va(1), va(1)];
%             ay = [va(2), va(2), va(2)+va(4), va(2)+va(4), va(2)];
%             
%             rt_index{end+1} = j; 
%         end
%     end
%     
%     rt_result{end+1} = va;
% end
% 
% fprintf('result len: %d \n', length(rt_result));
% figure, imshow(hu_bw);
% 
% for i = 1:length(rt_result)
%     v = rt_result{i};
%     showrt(v, 'r');
% end
% 
% 
% 
% % Merge rectangles.
% % figure, imshow(hu_bw);
% % rt_index = {};
% % for i = 1:nm
% %     
% %     area = stats(i).Area;
% %     if area < 100
% %         continue;
% %     end
% %     
% %     id = find([rt_index{:}] == i);
% %     if ~isempty(id)
% %         continue;
% %     else
% %         fprintf('i: %d \n', i);
% %     end
% %     
% % %     rt_index{end+1} = i;
% %     
% %     rt_a = stats(i).BoundingBox;
% %     rt_av = [rt_a(1), rt_a(2), rt_a(3), rt_a(4)];
% %     
% %     rt_a_x = [rt_av(1), rt_av(1)+rt_av(3), rt_av(1)+rt_av(3), rt_av(1), rt_av(1)];
% %     rt_a_y = [rt_av(2), rt_av(2), rt_av(2)+rt_av(4), rt_av(2)+rt_av(4), rt_av(2)];
% %     
% %     for j = (i+1):nm
% %         rt_b = stats(j).BoundingBox;
% %         rt_bv = [rt_b(1), rt_b(2), rt_b(3), rt_b(4)];
% %     
% %         rt_b_x = [rt_bv(1), rt_bv(1)+rt_bv(3), rt_bv(1)+rt_bv(3), rt_bv(1), rt_bv(1)];
% %         rt_b_y = [rt_bv(2), rt_bv(2), rt_bv(2)+rt_bv(4), rt_bv(2)+rt_bv(4), rt_bv(2)];
% %         
% %         in = inpolygon(rt_a_x, rt_a_y, rt_b_x, rt_b_y);
% %         in = in(1:4);
% %         id = find(in == 1);
% %         
% %         if isempty(id)
% %             % disjoint
% %         else
% %             % joint or inside
% %             fprintf('len id: %d \n', length(id));
% %             [c,rt,lx,ly,rx,ry,x0,y0] = Merge(rt_av,rt_bv);
% % %             showrt(rt, 'r');
% %             hu_bw(ly:ry, lx:rx) = 1;
% %             
% %             rt_av = rt;
% %             
% %             rt_a_x = [rt_av(1), rt_av(1)+rt_av(3), rt_av(1)+rt_av(3), rt_av(1), rt_av(1)];
% %             rt_a_y = [rt_av(2), rt_av(2), rt_av(2)+rt_av(4), rt_av(2)+rt_av(4), rt_av(2)];
% %             
% %             rt_index{end+1} = j;
% %         end
% %         
% %         
% %         
% % %         in1 = inpolygon(rt_a_x, rt_a_y, rt_b_x, rt_b_y);
% % %         in1 = in1(1:4);
% % %         id1 = find(in1 == 1);
% % %         in2 = inpolygon(rt_b_x, rt_b_y, rt_a_x, rt_a_y);
% % %         in2 = in1(1:4);
% % %         id2 = find(in2 == 1);
% % %         if length(id1) ~= length(id2)
% % %             fprintf('id1: %d id2: %d \n', length(id1), length(id2));
% % %         end
% % %         
% % %         if length(id1) ~= 4 && length(id1) ~= 2 && length(id1) ~= 1 && length(id1) ~= 0
% % %             fprintf('id1: %d id2: %d \n', length(id1), length(id2));
% % %         end
% % %         
% % %         % contain
% % %         if length(id1) == 4
% % %         end
% % %         
% % %         % intersect
% % %         if length(id1) == 2 || length(id1) == 1 || length(id1) == 4
% % %             [c,rt,lx,ly,rx,ry,x0,y0] = Merge(rt_av,rt_bv);
% % %             showrt(rt, 'r');
% % %         end
% % %         
% % %         % disjoint
% % %         if length(id1) == 0
% % %         end
% %     end
% % end
% % 
% % figure, imshow(hu_bw);
% % [L, nm] = bwlabel(hu_bw, 8);
% % stats = regionprops(L, 'BoundingBox', 'Area');
% % 
% % fprintf('nm: %d \n', nm);
% % 
% % for i = 1:nm
% %     rt = stats(i).BoundingBox;
% %     area = stats(i).Area;
% %     if area < 100
% %         continue;
% %     end
% %     v = [rt(1), rt(2), rt(3), rt(4)];
% %     showrt(v, 'r');
% % end

fprintf('End \n');

