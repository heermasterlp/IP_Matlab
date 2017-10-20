hu_files = '11.jpg';
hu_rgb = imread(hu_files);
ocrResults = ocr(hu_rgb);

Iocr = insertObjectAnnotation(hu_rgb, 'rectangle', ocrResults.WordBoundingBoxes, ocrResults.WordConfidences);

figure; imshow(Iocr);