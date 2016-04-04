
% labels: 0 for nothing (assigned by default)
%         1 for handicapped
%         2 for hydrant
%         3 for no parking

sign = 3; % use label ^^ number;
dir = './GMaps_Images';

switch(sign)
    case 1
        n = 15;
    case 2
        n = 35;
    case 3
        n= 33;
end

for i = 1:n
    switch(sign)
        case 1
            ROIs{i} = imread([dir '/handicapped/h' num2str(i) '.png']);
            labels{i} = 1;
        case 2
            ROIs{i} = imread([dir '/hydrant/f' num2str(i) '.png']);
            labels{i} = 2;
        case 3
            ROIs{i} = imread([dir '/noparking/n' num2str(i) '.png']);
            labels{i} = 3;
    end
end

switch(sign)
    case 1
        save('ROI_total_handicapped_4','ROIs')
        save('handicapped_4.mat','labels')
    case 2
        save('ROI_total_hydrant_4','ROIs')
        save('hydrant_4.mat','labels')
    case 3
        save('ROI_total_noparking_4','ROIs')
        save('noparking_4.mat','labels')
end

