% This code reads videos and crop each frame, and then write the output
% videos and all the frame images
% This code was designed for Georgia Tech ECE6258 class
% Instructor: Prof. Ghassan Alregib 
% School of electrical and computer Engineering 
% Georgia Institute of Technology
% Copyright 2015
% Author: Min-Hung (Steve) Chen
% Contact: cmhung.steven@gatech.edu
% Last Modified: v1.0 Sep-06-2015

close all
clear
clc

%=== Data path ===%
inputPath = './input videos/';
outputPath = './output videos/';
imagePath = './images/';

%=== List folder contents ===% 
drVideo = dir([inputPath '*.mp4']);
videoName = {drVideo.name}';
frameCount = 0;

%% Main algorithm 
tic;
for i=1:9%:length(videoName)
    
    disp(videoName{i}(1:end-4));
    readerobj = VideoReader([inputPath videoName{i}]); % object for the read input video
    writerObj = VideoWriter([outputPath videoName{i}],'MPEG-4'); % object for the output video we want to write

    open(writerObj);

    vidWidth = readerobj.Width; % video width
    vidHeight = readerobj.Height; % video height

    %=== design the cropping window ===% 
    row = vidHeight;
    col = vidWidth;  
    y_s =0; %vidHeight/4;
    x_s =0;% vidWidth/4;

    %=== write the output video and all frame images ===% 
    mov = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),'colormap',[]);
    for k=1:readerobj.NumberOfFrames
        tempFrame = read(readerobj,k);
        frameProc = tempFrame(y_s+1:y_s+row, x_s+1:x_s+col, :);
        mov(k).cdata = frameProc;
        imwrite(frameProc, [imagePath videoName{i}(1:end-4) '_frame_' num2str(k) '.png']);
        writeVideo(writerObj,mov(k));
    end

   close(writerObj);
end
toc;

%=== show the output ===% 
hf = figure;
set(hf,'position',[150 150 vidWidth vidHeight]);
movie(hf,mov,1,readerobj.FrameRate);


