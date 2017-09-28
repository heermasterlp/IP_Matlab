hu_files = '/Users/liupeng/Documents/UM/jiuchenggong/huangziyuan/KSS500_20021115_11594445-29.jpg';

hu_rgb = imread(hu_files);

figure, imshow(hu_rgb);

hu_gray = rgb2gray(hu_rgb);

figure, imshow(hu_gray);

