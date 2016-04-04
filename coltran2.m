
% send uint8 to the function
%channel=2 white , channel=1=blue, channel=3=red

function [vv,vv_center,blob_size]=coltran(pic,channel)

I=pic;
if nargin==2
    
    
    I2=I;
%gr=(rgb2gray(v));
v=I;
gr=rgb2gray(v);
v=double(gr);
figure
imshow(v,[])
[mm,nn]=size(v);
    
    I=double(I);
    hsvI = rgb2hsv(I);
    hueI = (hsvI(:,:,1));
    satI = hsvI(:,:,2);
    valI = hsvI(:,:,3);
    
    switch channel
        case 2
            %white = (satI<0.1)&(valI>=0.1);
            white = (hueI>=0.7)&(hueI<=0.9)&(satI<0.23)&(valI>=120);
            tran=white;
        case 1
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
    
    if channel==2
        
     [label,num] = bwlabel(img,4);
    Ar = regionprops(label, 'Area');
    smallAr = label;
    largeAr = label;
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
    
    
    img = total;
    kel = ones(9);
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
%%

%%
    elseif channel==1

[label,num] = bwlabel(img,4);
    Ar = regionprops(label, 'Area');
    smallAr = label;
    largeAr = label;
    for i = 1:num
        if (Ar(i).Area < 5)% MC
            smallAr(label==i) = 0;
        end
        if (Ar(i).Area > 700)%MC
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
    kel = ones(3);%MC
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
    
     img = total;%made change
          
    
%%


 elseif channel==3
        
        
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
%%%

    region = bwlabel(img,4);
    A = regionprops(region, 'Centroid');
    
    vv=zeros(size(v));
  [i j]=size(A);
   p=[];
   vv_center=[];
   count=1;
   blob_size=0;
   
   for ii=1:i
       p(ii,:)=round(A(ii).Centroid); 
       
       if channel==1
       if (p(ii,1)>21)&&(p(ii,1)<nn-21)&&(p(ii,2)>21)&&(p(ii,2)<mm-51)
           vv_center(count,:)=p(ii,:);
           count=count+1;           
          vv(p(ii,2)-20:p(ii,2)+50,p(ii,1)-20:p(ii,1)+20)=v(p(ii,2)-20:p(ii,2)+50,p(ii,1)-20:p(ii,1)+20);
           blob_size=[20,20,50,20];
       end
       
       elseif channel==2
           if (p(ii,1)>21)&&(p(ii,1)<nn-21)&&(p(ii,2)>21)&&(p(ii,2)<mm-21)
               vv_center(count,:)=p(ii,:);
               count=count+1;    
          vv(p(ii,2)-20:p(ii,2)+20,p(ii,1)-20:p(ii,1)+20)=v(p(ii,2)-20:p(ii,2)+20,p(ii,1)-20:p(ii,1)+20);
          blob_size=[20,20,20,20];
           end
           
       else
           if (p(ii,1)>21)&&(p(ii,1)<nn-21)&&(p(ii,2)>21)&&(p(ii,2)<mm-21)
               vv_center(count,:)=p(ii,:);
                count=count+1;    
          vv(p(ii,2)-20:p(ii,2)+20,p(ii,1)-20:p(ii,1)+20)=v(p(ii,2)-20:p(ii,2)+20,p(ii,1)-20:p(ii,1)+20);
          blob_size=[20,20,20,20];
           end
       end
       
       
   end
       figure;
       imshow((vv),[])
        
    
end


