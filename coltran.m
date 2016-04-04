% coltran function
% this function applies color transformation and color based segmentation
% to the frame.
% inputs: pic= extracted frame, channel= desired color, avg = mean of the image of normilization ,net= CNN information
%channel=1 white , channel=2=blue, channel=3=red
%outputs: vv_center: center of masses' locations of final blobs, prob: class score for each blob, classNum: class number 
%class number=     1 : nothing , 2:hanicapped   3:fire hydrant , %4:no-parking
% send uint8 to the function

% MatConvNet Vl_simplenn function is being called in this function


function [vv_center,prob,classNum]=coltran(pic,channel,avg,net)


%load 'data/cifar-baseline/net-epoch-15.mat'
classNum=1;

flag=0;
I=pic;
Ib=double(pic);

    
    
    I2=I;
%gr=(rgb2gray(v));
v=I;
gr=rgb2gray(v);
v=double(gr);

[mm,nn]=size(v);
    
    I=double(I);
    hsvI = rgb2hsv(I);
    hueI = (hsvI(:,:,1));
    satI = hsvI(:,:,2);
    valI = hsvI(:,:,3);
    
    switch channel % transforming the image to HSV color space
        case 1
            %white = (satI<0.1)&(valI>=0.1);
            white = (hueI>=0.7)&(hueI<=0.9)&(satI<0.23)&(valI>=120);
            tran=white;
            
            
            
            
        case 2
            blue = ((hueI>=0.57)&(hueI<0.72))&(satI>0.2)&(valI>=35);
            tran=blue;
        case 3
            
            for i=1:3
I2(:,:,i)=histeq(I2(:,:,i));
            end
            gra=rgb2gray(I2);

            red=I2(:,:,1);
            diff=imsubtract(red,gra);
            diff=medfilt2(diff,[3,3]);
             binred=im2bw(diff,0.09);
             tran=binred;
    end
       
    img=tran;
    
    
    %%color segmentation starts from here
    
    if (channel==2) %blue color
    %%computing the areas of blobs for the first round
     [label,num] = bwlabel(img,4);
    Ar = regionprops(label, 'Area');
    smallAr = label;
    largeAr = label;
    
    % small and large areas will be removed
    for i = 1:num
        if (Ar(i).Area < 10)
            smallAr(label==i) = 0;
        end
        if (Ar(i).Area > 500)
            largeAr(label==i) = 0;
        end        
    end
    
    
    total = zeros(size(label));
    for i = 1:size(img,1)
    for j = 1:size(img,2)
        if (smallAr(i,j)>0 && largeAr(i,j)>0)
            total(i,j) = 1;
        end
    end
    end
    
    % applying dilation to image, therefore possible segmented parts of an
    % object can get connected
    img = total;
    kel = ones(9);
    se = strel('arbitrary',kel);
    im = imdilate(img, se);
    %figure;imshow(im);title('after dilation');
    
    img = im;
    % remove blobs whose  largeAxis/smallAxis is too large
    [nl,num] = bwlabel(img, 4);    
    Longaxis = regionprops(nl, 'MajorAxisLength');
    Shortaxis = regionprops(nl, 'MinorAxisLength');
    
    img = nl;

    for i = 1:num
        if (Shortaxis(i).MinorAxisLength==0)
            img(nl==i) = 0;
        elseif (Longaxis(i).MajorAxisLength/Shortaxis(i).MinorAxisLength > 3)
            img(nl==i) = 0;
        end
    end
    
    % applying second round of eliminating very large and small areas
    [label,num] = bwlabel(img,4);
    Ar = regionprops(label, 'Area');
    smallAr = label;
    largeAr = label;
    for i = 1:num
        if (Ar(i).Area < 10)
            smallAr(label==i) = 0;
        end
        if (Ar(i).Area > 1000)
            largeAr(label==i) = 0;
        end        
    end
    
    
   total = zeros(size(label));
    for i = 1:size(img,1)
    for j = 1:size(img,2)
        if (smallAr(i,j)>0 && largeAr(i,j)>0)
            total(i,j) = 1;
        end
    end
    end
    
     img = total;
    
    
     
     %%
     
    elseif channel==1 %white color
        
     % the same procedure as discussed above
     [label,num] = bwlabel(img,4);
    Ar = regionprops(label, 'Area');
    smallAr = label;
    largeAr = label;
    for i = 1:num
        if (Ar(i).Area < 5)
            smallAr(label==i) = 0;
        end
        if (Ar(i).Area > 700)
            largeAr(label==i) = 0;
        end        
    end
    
    
    total = zeros(size(label));
    for i = 1:size(img,1)
    for j = 1:size(img,2)
        if (smallAr(i,j)>0 && largeAr(i,j)>0)
            total(i,j) = 1;
        end
    end
    end
    
    
    img = total;
    kel = ones(3);
    se = strel('arbitrary',kel);
    im = imdilate(img, se);
    %figure;imshow(im);title('after dilation');
    
    img = im;
    % remove region whose is largeAxis/smallAxis is too large
    [nl,num] = bwlabel(img, 4);    
    Longaxis = regionprops(nl, 'MajorAxisLength');
    Shortaxis = regionprops(nl, 'MinorAxisLength');
    
    img = nl;

    for i = 1:num
        if (Shortaxis(i).MinorAxisLength==0)
            img(nl==i) = 0;
        elseif (Longaxis(i).MajorAxisLength/Shortaxis(i).MinorAxisLength > 3)
            img(nl==i) = 0;
        end
    end
    
    
    [label,num] = bwlabel(img,4);
    Ar = regionprops(label, 'Area');
    smallAr = label;
    largeAr = label;
    for i = 1:num
        if (Ar(i).Area < 10)
            smallAr(label==i) = 0;
        end
        if (Ar(i).Area > 1000)
            largeAr(label==i) = 0;
        end        
    end
    
    
   total = zeros(size(label));
    for i = 1:size(img,1)
    for j = 1:size(img,2)
        if (smallAr(i,j)>0 && largeAr(i,j)>0)
            total(i,j) = 1;
        end
    end
    end
    
     img = total;
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
    %%
    elseif channel==3 %red color
        
        
      [label,num] = bwlabel(img,4);
    Ar = regionprops(label, 'Area');
    smallAr = label;
    largeAr = label;
    for i = 1:num
        if (Ar(i).Area < 10)
            smallAr(label==i) = 0;
        end
        if (Ar(i).Area > 750)
            largeAr(label==i) = 0;
        end        
    end
    
    
    total = zeros(size(label));
    for i = 1:size(img,1)
    for j = 1:size(img,2)
        if (smallAr(i,j)>0 && largeAr(i,j)>0)
            total(i,j) = 1;
        end
    end
    end
    
    
    img = total;
   % kel = ones(9);
   % se = strel('arbitrary',kel);
    %im = imdilate(img, se);
    %figure;imshow(im);title('after dilation');
    %  img = im;
    % remove region whose is largeAxis/smallAxis is too large
    
    [nl,num] = bwlabel(img, 4);    
    Longaxis = regionprops(nl, 'MajorAxisLength');
    Shortaxis = regionprops(nl, 'MinorAxisLength');
    
    img = nl;

    for i = 1:num
        if (Shortaxis(i).MinorAxisLength==0)
            img(nl==i) = 0;
        elseif (Longaxis(i).MajorAxisLength/Shortaxis(i).MinorAxisLength > 5)
            img(nl==i) = 0;
        end
    end
    
    
    [label,num] = bwlabel(img,4);
    Ar = regionprops(label, 'Area');
    smallAr = label;
    largeAr = label;
    for i = 1:num
        if (Ar(i).Area < 10)
            smallAr(label==i) = 0;
        end
        if (Ar(i).Area > 1000)
            largeAr(label==i) = 0;
        end        
    end
    
    
   total = zeros(size(label));
    for i = 1:size(img,1)
    for j = 1:size(img,2)
        if (smallAr(i,j)>0 && largeAr(i,j)>0)
            total(i,j) = 1;
        end
    end
    end
    
    
    end
        
        
        
        
        
         img = total; 
        
        
        
        
        
        
        

%%

%%
    


    region = bwlabel(img,4); % labeling the blobs so that we can compute their areas and center of masses
    A = regionprops(region, 'Centroid');
    
    vv=zeros(size(v));
  [i j]=size(A);
   p=[];
   vv_center=[];
   count=1;
   blob_size=0;
   temp_im3=zeros(nn,mm,3);
   
   for ii=1:i
       p(ii,:)=round(A(ii).Centroid); 
   
    %%
       
       if channel==1
       if (p(ii,1)>21)&&(p(ii,1)<nn-21)&&(p(ii,2)>21)&&(p(ii,2)<mm-51) % if the blob is within this frame, we process it 
                     
          temp_im=Ib(p(ii,2)-20:p(ii,2)+50,p(ii,1)-20:p(ii,1)+20,1:3);
%          i1=double(temp_im(:,:,1));
%i2=double(temp_im(:,:,2));
%i3=double(temp_im(:,:,3));
%m1=mean(i1(:));
%m2=mean(i2(:));
%m3=mean(i3(:));
%temp_im(:,:,1)=temp_im(:,:,1)-m1;
%temp_im(:,:,2)=temp_im(:,:,2)-m2;
%temp_im(:,:,3)=temp_im(:,:,3)-m3;
temp_im2=imresize(temp_im,[32,32]);
temp_im2=im2single(temp_im2);
temp_im2=temp_im2-avg; % normalizing the blobs
net.layers{end}.class = 1;
res = vl_simplenn(net, temp_im2); % calling a function from MatConvNet toolbox, please note that if you have not
%properly install the toolbox, you will get an error in this line.
% res contains every layer output of the CNN 

[~,num] = sort(res(end-1).x, 3, 'descend') ; % we sort the class score to find the highest probable class
class=num(:,:,1);           
          
        
          if class==3
              classNum=3;
              vv_center(count,:)=p(ii,:);
              prob(count) = max(exp(res(end-1).x)./sum(exp(res(end-1).x))); % normalizing the class score between 0 and 1
           count=count+1; 
           flag=1;
           %figure 
           %imshow(uint8(temp_im))
          
          end
          
       end
       
       
             
       %%
       elseif channel==2
           if (p(ii,1)>21)&&(p(ii,1)<nn-21)&&(p(ii,2)>21)&&(p(ii,2)<mm-21)
                  
          temp_im=Ib(p(ii,2)-20:p(ii,2)+20,p(ii,1)-20:p(ii,1)+20,1:3);
          
%          i1=double(temp_im(:,:,1));
%i2=double(temp_im(:,:,2));
%i3=double(temp_im(:,:,3));
%m1=mean(i1(:));
%m2=mean(i2(:));
%m3=mean(i3(:));
%temp_im(:,:,1)=temp_im(:,:,1)-m1;
%temp_im(:,:,2)=temp_im(:,:,2)-m2;
%temp_im(:,:,3)=temp_im(:,:,3)-m3;
temp_im2=imresize(temp_im,[32,32]);
temp_im2=im2single(temp_im2);
temp_im2=temp_im2-avg;

net.layers{end}.class = 1;
res = vl_simplenn(net, temp_im2);

[~,num] = sort(res(end-1).x, 3, 'descend') ;
class=num(:,:,1);

           if class==2
               classNum=2;
              vv_center(count,:)=p(ii,:);
              prob(count) = max(exp(res(end-1).x)./sum(exp(res(end-1).x)));
           count=count+1; 
           flag=1;
          % figure 
          % imshow(uint8(temp_im))
          end
          
          
         
           end
           %%
       else
           
           if (p(ii,1)>21)&&(p(ii,1)<nn-21)&&(p(ii,2)>21)&&(p(ii,2)<mm-21)
                 
          temp_im=Ib(p(ii,2)-20:p(ii,2)+20,p(ii,1)-20:p(ii,1)+20,1:3);
         temp_im3(p(ii,2)-20:p(ii,2)+20,p(ii,1)-20:p(ii,1)+20,1:3)=Ib(p(ii,2)-20:p(ii,2)+20,p(ii,1)-20:p(ii,1)+20,1:3);
          
     
          
           
 % i1=double(temp_im(:,:,1));
%i2=double(temp_im(:,:,2));
%i3=double(temp_im(:,:,3));
%m1=mean(i1(:));
%m2=mean(i2(:));
%m3=mean(i3(:));
%temp_im(:,:,1)=temp_im(:,:,1)-m1;
%temp_im(:,:,2)=temp_im(:,:,2)-m2;
%temp_im(:,:,3)=temp_im(:,:,3)-m3;


temp_im2=imresize(temp_im,[32,32]);
temp_im2=im2single(temp_im2);
temp_im2=temp_im2-avg;
net.layers{end}.class = 1;
res = vl_simplenn(net, temp_im2);

[~,num] = sort(res(end-1).x, 3, 'descend') ;
class=num(:,:,1)   ;  


           if class==4
               classNum=4;
              vv_center(count,:)=p(ii,:);
              prob(count) = max(exp(res(end-1).x)./sum(exp(res(end-1).x)));
           count=count+1; 
           flag=1;
           
           %figure 
           %imshow(uint8(temp_im))
           
          end
       
          
  end
           
         
           
       end
       
       %%
   end
      
        if flag==0;
            vv_center=[];
            prob=[];
        end
    
%figure
%imshow(uint8(temp_im3))
     


