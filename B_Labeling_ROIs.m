% Labeling ROIs
% labels: 0 for nothing (assigned by default)
%         1 for handicapped
%         2 for hydrant
%         3 for no parking
clear

sign = 2; % use label ^^ number;
vid = 3;
dir = '';

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

for  frame = 121:2:length(ROI_total);
    
    ROIs = ROI_total{frame};
    label = zeros(1,length(ROIs));

    M = ceil(sqrt(length(label)));
    fig = figure(423);clf;
    suptitle(['Frame: ' num2str(frame)]);
    set(fig,'position',[1300 50 600 950])
    for k = 1:length(label);
        subplot(M,M,k), imshow(ROIs{k},[])
        title(num2str(k));
    end
    
    % manually assign labels and assin back to 'labels' cell array
    disp(['frame: ' num2str(frame) '/' num2str(length(ROI_total))])
    x = input('Enter format:  [loc loc loc...] \n');

    if strcmp(x,'q')
        break
    end
    
    
    if ~isempty(x)
            label(x) = sign;
    end
    hand_labels{frame} = label;
    
end

switch(sign)
    case 1
        save([ 'labels_handicapped_' num2str(vid) '.mat'],'hand_labels');
    case 2
        save([ 'labels_hydrant_'  num2str(vid) '.mat'],'hand_labels');
    case 3
        save([ 'labels_noparking_'  num2str(vid) '.mat'],'hand_labels');
    case 0
        % nothing
end





