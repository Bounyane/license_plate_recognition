
clear all
close all
clc
%**************************************************************************
% Use Matlab to realize the license plate recognition, the steps are as follows:
% 1. Image data input
%**************************************************************************
img = imread('image01.jpg');
%**************************************************************************
% 2. Image conversion and preprocessing
%**************************************************************************
BWC1 = imcrop(img,[0 200 640 240]);
img1=rgb2gray(img);
img1=medfilt2(img1,[3 3]);
threshold = graythresh(img1);
BW = im2bw(img1,threshold);
BWC2 = imcrop(BW,[0 200 640 240]);
BW1 = imclearborder(BWC2,8);
BW2 = bwareaopen(BW1,1500,8);
se = strel('rectangle',[10 100]);
BW3 = imclose(BW2,se);
BW4 = imfill(BW3,'holes');
[L,NUM] = bwlabeln(BW4,8);
if NUM==1
    BW5 = (L==1);
elseif NUM==2
    BW5 = (L==2);
end

%**************************************************************************
% 3. Determine the location of the license plate
%**************************************************************************
L2 = bwlabel(BW5);
STATS = regionprops(L2, 'Centroid');
xc = round(STATS.Centroid(1,1));
yc = round(STATS.Centroid(1,2));
plate_x = xc - 110;
plate_y = yc - 27;
BW6 = imcrop(BW5,[plate_x plate_y 230 55]);
BW7 = imcrop(BWC1,[plate_x plate_y 230 55]);

%**************************************************************************
% 4. Position and cut
%**************************************************************************
plate = rgb2gray(BW7);
plate = medfilt2(plate,[3 3]);
threshold = graythresh(plate);
BWP = im2bw(plate,threshold - 0.1);
IBWP = imcomplement(BWP);
BWP2 = imclearborder(IBWP,8);
CBWP = bwareaopen(BWP2,90,8);
[L3, NUM2] = bwlabeln(CBWP);
for i = 1:NUM2
    object = bwlabel(L3 == i);
    stats2 = regionprops(object, 'BoundingBox');
    bounds = round(stats2.BoundingBox);
    characters{i} = imcomplement(imcrop(object, bounds));
end

%**************************************************************************
% 5. Binarization of license plate images
%**************************************************************************
A = imread('templates/A.bmp'); B = imread('templates/B.bmp');
C = imread('templates/C.bmp'); D = imread('templates/D.bmp');
E = imread('templates/E.bmp'); F = imread('templates/F.bmp');
G = imread('templates/G.bmp'); H = imread('templates/H.bmp');
I = imread('templates/I.bmp'); J = imread('templates/J.bmp');
K = imread('templates/K.bmp'); L = imread('templates/L.bmp');
M = imread('templates/M.bmp'); N = imread('templates/N.bmp');
O = imread('templates/O.bmp'); P = imread('templates/P.bmp');
Q = imread('templates/Q.bmp'); R = imread('templates/R.bmp');
S = imread('templates/S.bmp'); T = imread('templates/T.bmp');
U = imread('templates/U.bmp'); V = imread('templates/V.bmp');
W = imread('templates/W.bmp'); X = imread('templates/X.bmp');
Y = imread('templates/Y.bmp'); Z = imread('templates/Z.bmp');
one = imread('templates/1.bmp'); two = imread('templates/2.bmp');
three = imread('templates/3.bmp'); four = imread('templates/4.bmp');
five = imread('templates/5.bmp'); six = imread('templates/6.bmp');
seven = imread('templates/7.bmp'); eight = imread('templates/8.bmp');
nine = imread('templates/9.bmp'); zero = imread('templates/0.bmp');
letter = [A B C D E F G H I J K L M N O P Q R S T U V W X Y Z];
number = [one two three four five six seven eight nine zero];
character = [letter number];
templates = mat2cell(character, 42, [24 24 24 24 24 24 24 ...
    24 24 24 24 24 24 24 ...
    24 24 24 24 24 24 24 ...
    24 24 24 24 24 24 24 ...
    24 24 24 24 24 24 24 24]);
save ('templates', 'templates')

%**************************************************************************
% 6. Cut characters for recognition
%**************************************************************************
license_plate = [];
for i = 1:NUM2
    reschars{i} = imresize(characters{i}, [42 24]);
    charim = reschars{i};
    comp = [];
    load templates
    for n = 1:36
        sem = corr2(templates{1, n}, charim);
        comp = [comp sem];
    end
    vd = find(comp == max(comp));
    if vd == 1
        letter = 'A';
    elseif vd == 2
        letter = 'B';
    elseif vd == 3
        letter = 'C';
    elseif vd == 4
        letter = 'D';
    elseif vd == 5
        letter = 'E';
    elseif vd == 6
        letter = 'F';
    elseif vd == 7
        letter = 'G';
    elseif vd == 8
        letter = 'H';
    elseif vd == 9
        letter = 'I';
    elseif vd == 10
        letter = 'J';
    elseif vd == 11
        letter = 'K';
    elseif vd == 12
        letter = 'L';
    elseif vd == 13
        letter = 'M';
    elseif vd == 14
        letter = 'N';
    elseif vd == 15
        letter = 'O';
    elseif vd == 16
        letter = 'P';
    elseif vd == 17
        letter = 'Q';
    elseif vd == 18
        letter = 'R';
    elseif vd == 19
        letter = 'S';
    elseif vd == 20
        letter = 'T';
    elseif vd == 21
        letter = 'U';
    elseif vd == 22
        letter = 'V';
    elseif vd == 23
        letter = 'W';
    elseif vd == 24
        letter = 'X';
    elseif vd == 25
        letter = 'Y';
    elseif vd == 26
        letter = 'Z';
    elseif vd == 27
        letter = '1';
    elseif vd == 28
        letter = '2';
    elseif vd == 29
        letter = '3';
    elseif vd == 30
        letter = '4';
    elseif vd == 31
        letter = '5';
    elseif vd == 32
        letter = '6';
    elseif vd == 33
        letter = '7';
    elseif vd == 34
        letter = '8';
    elseif vd == 35
        letter = '9';
    else
        letter = '0';
    end
    license_plate = [license_plate letter];
end

figure
for i=1:NUM2
    subplot(1,8,i)
    imshow(characters{i})
end
figure
for i=1:NUM2
    subplot(1,8,i)
    imshow(reschars{i})
end

sprintf('Identified License Plate is : %s.', license_plate)
license_plate = []; % Clear 'license_plate' variable

%**************************************************************************
%-----------------end of script--------------------------------------------
