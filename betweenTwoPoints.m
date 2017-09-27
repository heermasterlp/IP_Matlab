function binside = betweenTwoPoints(p1,p2,p)

% Decide whether 'p' point is between 'p1' and 'p2'

binside = 0;

X = [p1(1,1),p2(1,1)];
Y = [p1(2,1),p2(2,1)];

maxx = max(X);
minx = min(X);
maxy = max(Y);
miny = min(Y);

x = p(1,1);     y = p(2,1);
bx = 0;     by = 0;

if x > minx & x < maxx
    bx = 1;
end

if y > miny & y < maxy
    by = 1;
end

if bx == 1 & by == 1
    binside = 1;
end