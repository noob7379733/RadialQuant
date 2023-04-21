%RadialQuantRegister
%Make sure that your images have a BLACK background. All images that you'd
%like to register should have a UNIQUE NAME, be in your MATLAB folder, and
%"Added to path..."

%Registered files will be saved automatically in your MATLAB folder.

clear all;
close all;
clc;

%Define fixed and moving images. Your fixed file should be the same for all
%images you want to compare in a RadialQuant histogram.
fixed_file = uigetfile('','Select Fixed File','*.*');
moving_file = uigetfile('','Select Moving File','*.*');

fixed = imread(fixed_file);
fixed = imbinarize(fixed);
fixed = im2uint8(fixed);
moving = imread(moving_file);
moving = imbinarize(moving);
moving = im2uint8(moving);

%Feel free to change the info collected by this prompt. However, DO NOT
%CHANGE THE FLIP QUESTION. This allows you to register left limbs with
%right limbs. For example, you may change 'Intact/Denervated?' to reflect
%experimental groups in your study.
prompt = {'Flip? Enter 1 for yes, 0 for no.','Animal ID','Intact/Denervated?','Region? (ex. ProxMet)'};
dlgtitle = 'Input';
dims = [1 35];
answer = inputdlg(prompt,dlgtitle,dims);

if str2double(answer(1)) == 1
    moving = flip(moving,2);
end

%Select control points.

[mp,fp] = cpselect(moving,fixed,'Wait',true);
t = fitgeotrans(mp,fp,'similarity');
Rfixed = imref2d(size(fixed));
movingRegistered = imwarp(moving,t);

%Determine rotation of transformation. Do NOT want to scale image.

u = [0 1]; 
v = [0 0]; 
[x, y] = transformPointsForward(t, u, v); 
dx = x(2) - x(1); 
dy = y(2) - y(1); 
angle = (180/pi) * atan2(dy, dx);

%Rotate registration image.

movingRotated = imrotate(moving,-angle);
% imwrite(movingRotated,strcat('Periosteum_rotated_',char(answer(2)),'_',char(answer(3)),'_',char(answer(4)),'.tif'))

save(strcat('t_',char(answer(2)),'_',char(answer(3)),'_',char(answer(4))),'t')
save(strcat('angle_',char(answer(2)),'_',char(answer(3)),'_',char(answer(4))),'angle')

figure
imshowpair(fixed, movingRotated,'Scaling','joint')

imwrite(movingRotated,strcat('Cortical_rotated_',char(answer(2)),'_',char(answer(3)),'_',char(answer(4)),'.tif'))

%Rotate feature masks images (i.e. axon tracings, single label tracings,
%etc.) The name of the file 'nerve_file' is just a placeholder and is
%unimportant. However, you may comment out/in blocks of code below (from
%nerve_file =... to imwrite(nerveRegistered...) to reflect the features you
%are measuring in your study.

% nerve_file = uigetfile('','Select CGRP File','*.*');
% nerve = imread(nerve_file);
% nerve = imbinarize(nerve);
% nerve = im2uint8(nerve);
% if str2double(answer(1)) == 1
%     nerve = flip(nerve,2);
% end
% nerveRegistered = imrotate(nerve,-angle);
% imwrite(nerveRegistered,strcat('CGRP_rotated_',char(answer(2)),'_',char(answer(3)),'_',char(answer(4)),'.tif'))
% 
% nerve_file = uigetfile('','Select Baf File','*.*');
% nerve = imread(nerve_file);
% nerve = imbinarize(nerve);
% nerve = im2uint8(nerve);
% if str2double(answer(1)) == 1
%     nerve = flip(nerve,2);
% end
% nerveRegistered = imrotate(nerve,-angle);
% imwrite(nerveRegistered,strcat('Baf_rotated_',char(answer(2)),'_',char(answer(3)),'_',char(answer(4)),'.tif'))
% 
% nerve_file = uigetfile('','Select TH File','*.*');
% nerve = imread(nerve_file);
% nerve = imbinarize(nerve);
% nerve = im2uint8(nerve);
% if str2double(answer(1)) == 1
%     nerve = flip(nerve,2);
% end
% nerveRegistered = imrotate(nerve,-angle);
% imwrite(nerveRegistered,strcat('TH_rotated_',char(answer(2)),'_',char(answer(3)),'_',char(answer(4)),'.tif'))
% 
% nerve_file = uigetfile('','Select Periosteum File','*.*');
% nerve = imread(nerve_file);
% nerve = imbinarize(nerve);
% nerve = im2uint8(nerve);
% if str2double(answer(1)) == 1
%     nerve = flip(nerve,2);
% end
% nerveRegistered = imrotate(nerve,-angle);
% imwrite(nerveRegistered,strcat('Periosteum_rotated_',char(answer(2)),'_',char(answer(3)),'_',char(answer(4)),'.tif'))

nerve_file = uigetfile('','Select Baf File','*.*');
nerve = imread(nerve_file);
nerve = imbinarize(nerve);
nerve = im2uint8(nerve);
if str2double(answer(1)) == 1
    nerve = flip(nerve,2);
end
nerveRegistered = imrotate(nerve,-angle);
imwrite(nerveRegistered,strcat('Baf_rotated_',char(answer(2)),'_',char(answer(3)),'_',char(answer(4)),'.tif'))

nerve_file = uigetfile('','Select Periosteum File','*.*');
nerve = imread(nerve_file);
nerve = imbinarize(nerve);
nerve = im2uint8(nerve);
if str2double(answer(1)) == 1
    nerve = flip(nerve,2);
end
nerveRegistered = imrotate(nerve,-angle);
imwrite(nerveRegistered,strcat('Periosteum_rotated_',char(answer(2)),'_',char(answer(3)),'_',char(answer(4)),'.tif'))

% nerve_file = uigetfile('','Select BS File','*.*');
% nerve = imread(nerve_file);
% nerve = imbinarize(nerve);
% nerve = im2uint8(nerve);
% if str2double(answer(1)) == 1
%     nerve = flip(nerve,2);
% end
% nerveRegistered = imrotate(nerve,-angle);
% imwrite(nerveRegistered,strcat('BS_rotated_',char(answer(2)),'_',char(answer(3)),'_',char(answer(4)),'.tif'))
% 
% nerve_file = uigetfile('','Select sLS File','*.*');
% nerve = imread(nerve_file);
% nerve = imbinarize(nerve);
% nerve = im2uint8(nerve);
% if str2double(answer(1)) == 1
%     nerve = flip(nerve,2);
% end
% nerveRegistered = imrotate(nerve,-angle);
% imwrite(nerveRegistered,strcat('sLS_rotated_',char(answer(2)),'_',char(answer(3)),'_',char(answer(4)),'.tif'))
% 
% nerve_file = uigetfile('','Select dLS File','*.*');
% nerve = imread(nerve_file);
% nerve = imbinarize(nerve);
% nerve = im2uint8(nerve);
% if str2double(answer(1)) == 1
%     nerve = flip(nerve,2);
% end
% nerveRegistered = imrotate(nerve,-angle);
% imwrite(nerveRegistered,strcat('dLS_rotated_',char(answer(2)),'_',char(answer(3)),'_',char(answer(4)),'.tif'))
% 
% nerve_file = uigetfile('','Select IrAr File','*.*');
% nerve = imread(nerve_file);
% nerve = imbinarize(nerve);
% nerve = im2uint8(nerve);
% nerve = imcomplement(nerve);
% if str2double(answer(1)) == 1
%     nerve = flip(nerve,2);
% end
% nerveRegistered = imrotate(nerve,-angle);
% imwrite(nerveRegistered,strcat('IrAr_rotated_',char(answer(2)),'_',char(answer(3)),'_',char(answer(4)),'.tif'))