% Used this code to check the labeling of blobs to make sure I didn't make
% any mistakes.

clear
sign = 2;
vid = 3;

switch(sign)
    case 1
        load(['ROI_total_handicapped_' num2str(vid) '.mat']);
        load(['labels_handicapped_' num2str(vid) '.mat']);
    case 2
        load(['ROI_total_hydrant_' num2str(vid) '.mat']);
        load(['labels_hydrant_' num2str(vid) '.mat']);
    case 3
        load(['ROI_total_noparking_' num2str(vid) '.mat']);
        load(['labels_noparking_' num2str(vid) '.mat']);
end


for  frame = 100:2:length(ROI_total);
    
    ROIs = ROI_total{frame};
    label = hand_labels{frame};

    M = ceil(sqrt(length(label)));
    fig = figure(423);clf;
    suptitle(['Frame: ' num2str(frame)]);
    set(fig,'position',[1300 50 600 950])
    
    for k = 1:length(label);
        subplot(M,M,k), imshow(ROIs{k},[])
        title(num2str(label(k)));
    end
   
    pause
    
end