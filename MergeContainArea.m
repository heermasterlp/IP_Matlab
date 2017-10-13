function rbw = MergeContainArea(bw, Trectarea)

% Merge the areas which are contained by each other

stop = 1;

while stop ~= 0
    
    [L,nm] = bwlabel(bw,8);
    stats = regionprops(L,'BoundingBox','Area');

    non = 0;
    
    for i = 1:nm    
        rt = stats(i).BoundingBox;
        a = stats(i).Area;
        
        if a < Trectarea
            fprintf('a:%d \n', a);
            continue;
        end

        v = [rt(1),rt(2),rt(3),rt(4)];

        x = [rt(1),rt(1)+rt(3),rt(1)+rt(3),rt(1),rt(1)];
        y = [rt(2),rt(2),rt(2)+rt(4),rt(2)+rt(4),rt(2)];

        for j = (i+1):nm 
            onert = stats(j).BoundingBox;
            onea = stats(j).Area;
            onev = [onert(1),onert(2),onert(3),onert(4)];

            x1 = [onert(1),onert(1)+onert(3),onert(1)+onert(3),onert(1),onert(1)];
            y1 = [onert(2),onert(2),onert(2)+onert(4),onert(2)+onert(4),onert(2)];

            in = inpolygon(x1,y1,x,y);
            in = in(1:4);
            id = find(in == 1);
            in1 = inpolygon(x,y,x1,y1);
            in1 = in(1:4);
            id1 = find(in1 == 1);

            if length(id) == 0 && length(id1) == 0
                
            elseif length(id) == 4
                non = 1;
                disp('(x,y) inside (x1, y1)');

                [r,c] = find(L == j);
                np = length(r);

                for t = 1:np
                    bw(r(t,1),c(t,1)) = 0;
                end

            elseif length(id1) == 4
                non = 1;
                disp('(x1, y1) inside (x, y)');

                [r,c] = find(L == i);
                np = length(r);

                for t = 1:np
                    bw(r(t,1),c(t,1)) = 0;
                end
            end
        end
    end
    if non == 0
        stop = 0;
        break;
    end
end

rbw = bw;
