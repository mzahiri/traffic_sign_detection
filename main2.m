
% this is the main script. in this code we assume that user is looking for a
% specific traffic sign in the video, so the user will be asked to choose
% what sign they are looking for.

% in this case all 9 videos used for training the CNN

clear
clc

imdb = load ('imdb.mat'); % loading the dataset
load 'net-epoch-15.mat' % loading CNN parameters and layers
avg=imdb.images.data_mean; % loading image mean, this mean will be later subtracted from the new blobs 
vidObj = VideoReader('/Users/mohammad/Desktop/input_videos/no parking sign_3.mp4'); % loading the video
vidHeight = vidObj.Height;
vidWidth = vidObj.Width;
s = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),'colormap',[]);
k = 1;

% this the following section, user is asked to choose what traffic sign
% they want to detect in the frame.
% user must input a number between 1 and 3 where fire hydrant=1, hanidcapped=2 and no-parking=3
prompt = {'What sign you are looking for? Enter a number between 1 to 3: fire hydrant=1, hanidcapped=2 and no-parking=3 '}; 
dlg_title = 'Input';
num_lines = 1;
defaultans = {'0'};
answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
color=str2num(answer{1});

switch color % desired color is targeted 
    case 1
        color123=1;
    case 2
        color123=2;
    case 3
        color123=3;
    otherwise
        error('you entered a wrong number, choose a number between 1 to 3');
        
end



while hasFrame(vidObj)
    
    s(k).cdata = readFrame(vidObj);% each extracted frame is being sent to coltran function 
    
  % frame will be sent to coltran function to find out more relevent blobs.
  % the output of coltran is limited number of blobs, with their corresponding class
  % score and their center of masses
    [center,prob,class]=coltran(s(k).cdata,color123,avg,net); 
    
    if ~isempty(center)
        for i=1:length(prob)
    if prob(i)>0.8 %class score
    s(k).cdata= insertShape(s(k).cdata, 'Rectangle', [center(i,1)-25 center(i,2)-25 50 50], 'LineWidth', 2);% using the center of masses' locations possible desired object will be highlighted
    if color123==1
    s(k).cdata = insertText(s(k).cdata,[center(i,1)-50,center(i,2)-50],'fire hydrant');
    elseif color123==2
   s(k).cdata = insertText(s(k).cdata,[center(i,1)-50,center(i,2)-50],'handicapped');     
    else
     s(k).cdata = insertText(s(k).cdata,[center(i,1)-50,center(i,2)-50],'no-parking');   
    end
    
    end
    
        end
    end
    
    
    k = k+1;
end

set(gcf,'position',[150 150 vidObj.Width vidObj.Height]);
set(gca,'units','pixels');
set(gca,'position',[0 0 vidObj.Width vidObj.Height]);

movie(s,1,vidObj.FrameRate); % running the video
rectangle('Position',[355 220 100 100], 'LineWidth',2, 'EdgeColor','b');

v= VideoWriter('video1'); % video is saved with this video1 name, and it is in avi format
open(v);
writeVideo(v,s);
close(v);
%%
%clear
%clc
%I=imread('/Users/Desktop/images/no parking sign_2_frame_30.png');
%I=imread('/Users/Desktop/images/no parking sign_3_frame_70.png');
%I=imread('/Users/Desktop/images/handicapped_2_frame_90.png');
%I=imread('/Users/Desktop/images/fire hydrant_3_frame_95.png');
%I=imread('/Users/Desktop/images/fire hydrant_1_frame_15.png');
%imdb = load('data/cifar-baseline/imdb.mat');
%load 'data/cifar-baseline/net.mat';
%avg=imdb.images.data_mean;
%[center,prob,class]=coltran(I,3,avg);
%for i=1:length(prob)
 %   I= insertShape(I, 'Rectangle', [center(i,1)-25 center(i,2)-25 50 50], 'LineWidth', 2);
%end
%figure
%imshow(uint8(I))
