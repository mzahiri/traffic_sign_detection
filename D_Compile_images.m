% Compile the labeled image data from different videos into a single file
clear

% addpath(genpath('Labeling Group 1'));
% addpath(genpath('Labeling Group 2'));
% addpath(genpath('Re-Labeling Group 1'));

sampling = 1; 

% hydrant: train 2 and 3 validate on 1
% handicapped: train 1 and 3 validate on 2
% noparking: train 1 and 3 validate on 2

mode = 2; % 1 train, 2 validate

%% Training
% Compile all images into one cell array
if mode == 1
% Labeling Group 1
image_idx = 1;
num_repeat = 2; % add these images to the dataset multiple times

for k = 1:6

    switch(k)
        case 1
            load('labels_handicapped_1.mat');
            load('ROI_total_handicapped_1.mat');
        case 2
            load('labels_handicapped_3.mat');
            load('ROI_total_handicapped_3.mat');
        case 3
            load('labels_hydrant_2.mat');
            load('ROI_total_hydrant_2.mat');
        case 4
            load('labels_hydrant_3.mat');
            load('ROI_total_hydrant_3.mat');
        case 5
            load('labels_noparking_1.mat');
            load('ROI_total_noparking_1.mat');
        case 6
            load('labels_noparking_3.mat');
            load('ROI_total_noparking_3.mat');
    end
    
    for frame = 1:sampling:length(hand_labels)
        if ~isempty(hand_labels{frame})
            % loop over ROIs in a frame
            for r = 1:length(ROI_total{frame})
               
                for k = 1:1%num_repeat
                    images_cells{image_idx} = imresize(ROI_total{frame}{r},[32 32]);
                    labels_cells{image_idx} = hand_labels{frame}(r);
                    image_idx = image_idx + 1;
                end
            end
        end
    end
end




% Labeling Group 2
num_repeat = 5; % add these images to the dataset multiple times

file = 1;
for k = 1:3;
    switch file
        case 1
            load('labels_handicapped_4.mat')
            load('ROI_total_handicapped_4.mat');
        case 2
            load('labels_hydrant_4.mat')
            load('ROI_total_hydrant_4.mat');
        case 3
            load('labels_noparking_4.mat')
            load('ROI_total_noparking_4.mat');
    end
    
    for k = 1:num_repeat
        for r = 1:length(hand_labels)
            images_cells{image_idx} = imresize(ROIs{r},[32 32]);
            labels_cells{image_idx} = hand_labels(r);
            image_idx = image_idx + 1;
        end
    end
    
    
    file = file+1;
end


 save('compile_images_output_train','labels_cells','images_cells')






%% Validation Set
elseif mode == 2
image_idx = 1;
num_repeat = 2; % add these images to the dataset multiple times

for k = 1:3
    switch k
        case 1
            load('labels_handicapped_2.mat');
            load('ROI_total_handicapped_2.mat');
        case 2
            
            load('labels_hydrant_1.mat');
            load('ROI_total_hydrant_1.mat');
        case 3
            
            load('labels_noparking_2.mat');
            load('ROI_total_noparking_2.mat');
    end
    
    for frame = 2:sampling:length(hand_labels)
        if ~isempty(hand_labels{frame})
            % loop over ROIs in a frame
            for r = 1:length(ROI_total{frame})
                
              % add multiple copies of signs
                for k = 1:1%num_repeat
                    images_cells{image_idx} = imresize(ROI_total{frame}{r},[32 32]);
                    labels_cells{image_idx} = hand_labels{frame}(r);
                    image_idx = image_idx + 1;
                end
            end
        end
    end
end

save('compile_images_output_validate','labels_cells','images_cells')

end
