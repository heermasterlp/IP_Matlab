function MergeCrossArea(bw,Tseperate)

% Merge areas which are crossing each other

dfile = 'ca.dat';
rfile = 'r.dat';

m = '';
dlmwrite(dfile,m);
dlmwrite(rfile,m);

[L,nm] = bwlabel(bw,8);
stats = regionprops(L,'BoundingBox','Centroid');

for i = 1:nm
    rt = stats(i).BoundingBox;
    c = stats(i).Centroid;

    dlmwrite(dfile, c, '-append', 'delimiter','\t');
    dlmwrite(dfile, rt, '-append', 'delimiter','\t');
end

file = textread(dfile,'%s','delimiter','\n','whitespace','','bufsize',4095);
nline = length(file);

mid = [];

narea = nline/2;

for aid = 1:narea
    
    fid = find(aid == mid);
    if length(fid) == 0
        mid = [mid,aid];    % record discussed areas

        lid = (aid-1)*2+1;
        icen = strread(file{lid},'%s');
        irt = strread(file{lid+1},'%s');

        cen = [str2num(icen{1,1});str2num(icen{2,1})];
        showpt(cen,'ro');

        rt = [];
        for i = 1:4
            t = str2num(irt{i,1});
            rt = [rt,t];
        end

        % Left-Up corner
        lx = rt(1);
        ly = rt(2);

        % Right-Down corner
        rx = rt(1)+rt(3);
        ry = rt(2)+rt(4);

        x0 = [lx,rx,rx,lx,lx];
        y0 = [ly,ly,ry,ry,ly];

        showrt(rt,'b');

        for j = aid+1:narea 

            id = find(j == mid);
            if length(id) == 0

                lid = (j-1)*2+1;
                icen = strread(file{lid},'%s');
                irt = strread(file{lid+1},'%s');

                cenj = [str2num(icen{1,1});str2num(icen{2,1})];

                rtj = [];
                for i = 1:4
                    t = str2num(irt{i,1});
                    rtj = [rtj,t];
                end

                showrt(rtj,'r');

                % Left-Up corner
                lxj = rtj(1);
                lyj = rtj(2);

                % Right-Down corner
                rxj = rtj(1)+rtj(3);
                ryj = rtj(2)+rtj(4);

                xj = [lxj,rxj,rxj,lxj,lxj];
                yj = [lyj,lyj,ryj,ryj,lyj];

                in = inpolygon(xj,yj,x0,y0);
                in = in(1:4);
                id = find(in == 1);
                in1 = inpolygon(x0,y0,xj,yj);
                in1 = in(1:4);
                id1 = find(in1 == 1);

                if length(id) == 0

                    disp('Xiangli');
                    showpt(cenj,'go');
                    dist = distance_twoPoints(cen,cenj);

                    % Define threshold of distance to be 'Tseperate'
                    if dist <= Tseperate  % Merge two polygons
                        
                        [c,rt,lx,ly,rx,ry,x0,y0] = Merge(rt,rtj);
                        cen = [c(1);c(2)];
                        mid = [mid,j];
                    end

                elseif length(id) == 1 & length(id1) == 1
                    
                    disp('Chonghe');
                    showpt(cenj,'mo');

                    [c,rt,lx,ly,rx,ry,x0,y0] = Merge(rt,rtj);
                    cen = [c(1);c(2)];
                    mid = [mid,j];

                elseif length(id) == 2 & length(id1) == 2
                    
                    disp('Jiaocha');
                    showpt(cenj,'co');

                    [c,rt,lx,ly,rx,ry,x0,y0] = Merge(rt,rtj);
                    cen = [c(1);c(2)];
                    mid = [mid,j];
                end
            end
        end
        
        if j == narea
            
            showpt(cen,'ro');

            dlmwrite(rfile, c, '-append', 'delimiter','\t');
            dlmwrite(rfile, rt, '-append', 'delimiter','\t');
        end
    end
end
