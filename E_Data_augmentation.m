% Perform some data augmentation and compile data into training and
% validation sets.  Then put data into CNN-ready "batch" format


%% Data Augmentation
    clear
    
    % Mode: 1 imput is train only, 2 validate only, 3 mixed, split at end
    mode = 2; 
    
    if mode == 1
        load('compile_images_output_train');
        num_remove = 0; % number of 0's to remove
        
%         labels_cells{13407} = 2;
%         labels_cells{13408} = 2;
%         labels_cells{20900} = 3;
%         labels_cells{20901} = 3;
        
    elseif mode == 2
        load('compile_images_output_validate');
        num_remove = 0; % number of 0's to remove
        
%         labels_cells{12268} = 3;
%         labels_cells{12269} = 3;
%         labels_cells{12270} = 3;
          for l = 7115:7126
%               labels_cells{l} = 2;
          end
    else
        load('compile_images_output_all');
        num_remove = 0;
    end
    
    % Inspect labels, fix errors, look at histogram
    labels_array = cell2mat(labels_cells);
    stem(labels_array);
    a = hist(labels_array,4)
    
    % Randomize Images
    idx = randperm(length(labels_array));
    images_cells = images_cells(idx);
    labels_cells = labels_cells(idx);

    removed = 0;

    for i = 1:length(labels_cells)
        
        % Remove some 0's
        if labels_cells{i} == 0 && removed < num_remove
            labels_cells{i} = [];
            images_cells{i} = [];
            removed = removed + 1;
        else
            % Duplicate signs with noise
            if labels_cells{i} > 0
                images_cells{end+1} = imnoise(images_cells{i},'gaussian',0,.001);
                labels_cells{end+1} = labels_cells{i};
                images_cells{end+1} = imnoise(images_cells{i},'salt & pepper');
                labels_cells{end+1} = labels_cells{i};
                images_cells{end+1} = imnoise(images_cells{i},'poisson');
                labels_cells{end+1} = labels_cells{i};

%                 imshow(images_cells{end},[])
%                 labels_cells{i}
%                 pause
            end
            
            % boost sign 2
%             if labels_cells{i} > 0 %mode == 2 && labels_cells{i} == 2 
%                 
%                 for k = 1
%                     images_cells{end+1} = imnoise(images_cells{i},'salt & pepper');
%                     labels_cells{end+1} = labels_cells{i};
%                     images_cells{end+1} = imnoise(images_cells{i},'poisson');
%                     labels_cells{end+1} = labels_cells{i};
%                 end
%             
%             % boost sign 3
%             elseif mode == 2 && labels_cells{i} == 3
%                 for k = 1
%                     images_cells{end+1} = imnoise(images_cells{i},'salt & pepper');
%                     labels_cells{end+1} = labels_cells{i};
%                     images_cells{end+1} = imnoise(images_cells{i},'poisson');
%                     labels_cells{end+1} = labels_cells{i};
%                 end
%                 
%                 %                 imshow(images_cells{end},[])
%                 %                 labels_cells{i}
%                 %                 pause
%             end
        end
    end

    % Remove the empty cell elements
    labels_cells(cellfun(@(labels_cells) isempty(labels_cells),labels_cells))=[];
    images_cells(cellfun(@(images_cells) isempty(images_cells),images_cells))=[];
    
    % Re-randomize
    idx = randperm(length(labels_cells));
    images_cells = images_cells(idx);
    labels_cells = labels_cells(idx);

    % New Histogram
    labels_array = cell2mat(labels_cells);
    plot(labels_array);
    a_out = hist(labels_array,4)
    
    
    %% Save into batch format
    images_all = zeros(length(labels_cells),3*32^2);
    labels_all = 6*ones(length(labels_cells),1);
    
    for i = 1:length(labels_cells)
       R = transpose(images_cells{i}(:,:,1));
       G = transpose(images_cells{i}(:,:,2));
       B = transpose(images_cells{i}(:,:,3));
       
       images_all(i,:) = [reshape(R,[1 32^2]) reshape(G,[1 32^2]) reshape(B,[1 32^2]) ];
       labels_all(i) = labels_cells{i};
       
    end

    % Divide into train and val if necessary
    if mode == 1
        num_train = length(labels_all);
        labels_all1 = labels_all;
        images_all1 = images_all;
    elseif mode ==2
        labels_all2 = labels_all;
        images_all2 = images_all;
    elseif mode == 3
        num_train = floor(length(labels_all)*.8);
        num_validate = length(labels_cells) - num_train;
        
        labels_all1 = labels_all(1:num_train);
        images_all1 = images_all(1:num_train,:);
        
        labels_all2 = labels_all(num_train+1:end);
        images_all2 = images_all(num_train+1:end,:);
    end
    
    % Put into batches
    if mode == 1 || mode == 3
        N = ceil(num_train/5);
        for i = 1:4
            labels = labels_all1((i-1)*N+1:i*N);
            data = images_all1((i-1)*N+1:i*N,:);
            batch_label = ['training batch ' num2str(i) ' of 5' ];
            save(['data_batch_' num2str(i)],'data','labels','batch_label')
        end
        i =5;
        labels = labels_all1((i-1)*N+1:end);
        data = images_all1((i-1)*N+1:end,:);
        batch_label = ['training batch ' num2str(i) ' of 5'];
        save(['data_batch_' num2str(i)],'data','labels','batch_label')
    end
    if mode == 2 || mode == 3
        data = images_all2;
        labels = labels_all2;
        batch_label = ['testing batch 1 of 1'];
        save('test_batch','data','labels','batch_label') 
    end
    
    