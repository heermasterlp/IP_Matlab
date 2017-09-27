function [c,newrt,lx,ly,rx,ry,x0,y0] = Merge(rt,rtj)

% Merge two polygons

% Left-Up corner
lx = rt(1);
ly = rt(2);

% Right-Down corner
rx = rt(1)+rt(3);
ry = rt(2)+rt(4);

% Left-Up corner
lxj = rtj(1);
lyj = rtj(2);

% Right-Down corner
rxj = rtj(1)+rtj(3);
ryj = rtj(2)+rtj(4);

nlx = min(lx,lxj);
nly = min(ly,lyj);

nrx = max(rx,rxj);
nry = max(ry,ryj);

newrt = [nlx,nly,(nrx-nlx),(nry-nly)];
showrt(newrt,'g');

% Merge
c = [(nrx+nlx)/2,(nry+nly)/2];

% Left-Up corner
lx = newrt(1);
ly = newrt(2);

% Right-Down corner
rx = newrt(1)+newrt(3);
ry = newrt(2)+newrt(4);

x0 = [lx,rx,rx,lx,lx];
y0 = [ly,ly,ry,ry,ly];

plot(x0(3),y0(3),'go');
hold on;
