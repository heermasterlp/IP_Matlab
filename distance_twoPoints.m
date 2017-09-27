function dist = distance_twoPoints(p1, p2)

% Calculate the distance between the two points

x1 = p1(1,:);
y1 = p1(2,:);

x2 = p2(1,:);
y2 = p2(2,:);

dist = sqrt((x1-x2).^2 + (y1-y2).^2);