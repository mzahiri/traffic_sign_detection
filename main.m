% this main file is similar to other main.m that were commented and provided, the
% difference in this file is that in each time we take a frame and run the
% coltran function (color segmentation) on all 3 possible colors. this algorithm does not count
% number of occurence of each class, there is no preprocessing. Thus we
% should expect to see many false positives in the detection.

%% important note: in this code the CNN was only trained on 6 videos and will be 
% validated on 3 videos. In addition algorithm was not told to look for
% what particular color, as descriped above it runs the color
% segmentation function for all 3 possible colors on each frame. Since
% there is no preprocessing we should expect to observe too many false
% positives, specially on validated videos.





% addpath('C:\Users\Documents\School\Graduate_School\Spring2015\ECE6254\Project\matconvnet-master');
% addpath('C:\Users\Documents\School\Graduate_School\Spring2015\ECE6254\Project\matconvnet-master\matlab\xtest');
% addpath('C:\Users\Documents\School\Graduate_School\Spring2015\ECE6254\Project\matconvnet-master\matlab\mex');
% addpath('C:\Users\Documents\School\Graduate_School\Spring2015\ECE6254\Project\matconvnet-master\matlab');
% addpath('C:\Users\Documents\School\Graduate_School\Spring2015\ECE6254\Project\matconvnet-master');

% profile on

clear
imdb = load('imdb.mat');% loading the dataset
load('net-epoch-11.mat');% loading CNN parameters and layers
avg=imdb.images.data_mean; % loading image mean, this mean will be later subtracted from the new blobs

% loop over signs
for file = 1:9
    tic
    
    switch(file)
        case 1
            sign_file = 'handicapped_1'
        case 2
            sign_file = 'handicapped_2'
        case 3
            sign_file = 'handicapped_3'
        case 4
            sign_file = 'fire hydrant_1'
        case 5
            sign_file = 'fire hydrant_2'  
        case 6
            sign_file = 'fire hydrant_3'
        case 7
            sign_file = 'no parking sign_1'
        case 8
            sign_file = 'no parking sign_2'
        case 9
            sign_file = 'no parking sign_3'
    end
    
vidObj = VideoReader(['C:\Users\Michael\Documents\School\Graduate_School\Fall2015\ECE6258\Project\' sign_file '.mp4']);
vidHeight = vidObj.Height;
vidWidth = vidObj.Width;
s = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),'colormap',[]);
k = 1;

while hasFrame(vidObj)
    
    s(k).cdata = (readFrame(vidObj));
    
    for jj=1:3
        
        
        % frame will be sent to coltran function to find out more relevent blobs.
  % the output of coltran is limited number of blobs, with their corresponding class
  % score and their center of masses
        
        
        [center,prob,classNum]=coltran(s(k).cdata,jj,avg,net);
        % [center,prob,classNum]=coltran(s(k).cdata,3,avg,net);
        
        if (jj==1)&&(classNum==3)
            if ~isempty(center)
                for i=1:length(prob)
                    if prob(i)>0.8
                        s(k).cdata= insertShape(s(k).cdata, 'Rectangle', [center(i,1)-25 center(i,2)-25 50 50], 'LineWidth', 2);
                    end
                end
                s(k).cdata = insertText(s(k).cdata,[vidHeight/2,(vidWidth/2)-300],'fire_hydrant');
            end
            
        elseif (jj==2)&&(classNum==2)
            
            if ~isempty(center)
                for i=1:length(prob)
                    if prob(i)>0.8
                        s(k).cdata= insertShape(s(k).cdata, 'Rectangle', [center(i,1)-25 center(i,2)-25 50 50], 'LineWidth', 2);
                    end
                end
                s(k).cdata = insertText(s(k).cdata,[vidHeight/2,80],'handicapped');
            end
            
        elseif (jj==3)&&(classNum==4)
            if ~isempty(center)
                for i=1:length(prob)
                    if prob(i)>0.8
                        s(k).cdata= insertShape(s(k).cdata, 'Rectangle', [center(i,1)-25 center(i,2)-25 50 50], 'LineWidth', 2);
                    end
                end
                s(k).cdata = insertText(s(k).cdata,[vidHeight/2,80],'no_parking');
            end
        end
    end
    k = k+1;
end


%set(gcf,'position',[150 150 vidObj.Width vidObj.Height]);
%set(gca,'units','pixels');
%set(gca,'position',[0 0 vidObj.Width vidObj.Height]);

%movie(s,1,vidObj.FrameRate);
%rectangle('Position',[355 220 100 100], 'LineWidth',2, 'EdgeColor','b');

v= VideoWriter(sign_file);
open(v);
writeVideo(v,s);
close(v);
toc
end


% profile viewer


%imdb = load('data/cifar-baseline/imdb.mat');
%load 'data/cifar-baseline/net.mat';
%avg=imdb.images.data_mean;
%[center,prob,class]=coltran(I,3,avg);
%for i=1:length(prob)
%   I= insertShape(I, 'Rectangle', [center(i,1)-25 center(i,2)-25 50 50], 'LineWidth', 2);
%end
%figure
%imshow(uint8(I))
