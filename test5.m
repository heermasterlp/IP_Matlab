hu_files = '111.jpg';
hu_rgb = imread(hu_files);
hu_gray = rgb2gray(hu_rgb);
hu_bw = im2bw(hu_gray, 0.3);
hu_bw = ~hu_bw;
figure; imshow(hu_bw);

gc = ~hu_bw;
figure; imshow(gc);
D = bwdist(gc);
figure; imshow(D);
L = watershed(-D);
w = L==0;
figure; imshow(w);
g2 = hu_bw & ~w;
figure; imshow(g2);



