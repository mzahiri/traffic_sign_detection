%% Generate ROIs
% This code is used to grab a set of ROI's from a frame using the coltran
% function.  After this they will go to the Labeling_ROIs script

clear
% sign_num: 0 for nothing 
%           1 for handicapped
%           2 for hydrant
%           3 for no parking

        
% Directories
im_dir = './Images/Video_Images/';


for sign_num = 2
    for vid_num = 1:3


last_frames = [323 317 510 ;... % handicapped 1 2 3
               264 246 252;...  % hydrant 1 2 3
               196  91 177];    % no parking 1 2 3


switch sign_num
    case 1
        num_frames = last_frames(sign_num,vid_num);
        im_sign = ['handicapped' '_' num2str(vid_num) '_frame_'];
    case 2
        num_frames = last_frames(sign_num,vid_num);
        im_sign = ['fire hydrant' '_' num2str(vid_num) '_frame_'];
    case 3
        num_frames = last_frames(sign_num,vid_num);
        im_sign = ['no parking sign' '_' num2str(vid_num) '_frame_'];
end


for  frame = 1:num_frames;
    
    %% Load Original Image
        frame_rgb = imread([im_dir im_sign num2str(frame) '.png']);
        %figure(551), imshow(frame_rgb);

    %% Color transformation
        
        [clr_tran(:,:,frame), centroids, region]= coltran2(frame_rgb,sign_num);
        
        num_ROIs = length(centroids(:,1));
        
        % here we grab a blob (aka ROI) from the images using the
        % cordinates from coltran
        for i = 1:num_ROIs
           a = centroids(i,2)-region(1): centroids(i,2)+region(3);
           b = centroids(i,1)-region(4): centroids(i,1)+region(2);
           ROI{i}=frame_rgb(a,b,:);
            
        end
        ROI_total{frame} = ROI;
        clear ROI
%         figure(938),clf, imshow(clr_tran(:,:,frame),[]); title('clr tran');
%         figure(235),clf, imshow(ROI(:,:,2),[]);

end

save_dir = '.\ROIs\';

switch sign_num
    case 1
        save(['ROI_total_handicapped_' num2str(vid_num)],'ROI_total');
    case 2
        save(['ROI_total_hydrant_' num2str(vid_num)],'ROI_total');
    case 3
        save(['ROI_total_noparking_' num2str(vid_num)],'ROI_total');
end

clear ROI_total;

    end
end

