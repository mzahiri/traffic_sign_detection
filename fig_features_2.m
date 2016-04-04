imdb = load('data/cifar-baseline/imdb.mat');
load 'data/cifar-baseline/net-epoch-2.mat'
%%
imN = 486;

im2 = imdb.images.data(:,:,:,imN) ;
labels = imdb.images.labels(1,imN) ;

net.layers{end}.class = 1;%imdb.images.labels(1,imN) ;
res = vl_simplenn(net, im2);


im = res(1).x+ imdb.images.data_mean;

% im2 = zeros(32,32,3);
% im2(:,:,1) = 1;
[row,col,vol] =size(res(2).x);
pSize = [row col]/16;

figure
h = 15;
w = 15;
setfigure(w,h,3,6)
axes('units','centimeters','pos',[ 0 h/2-1  pSize])
image(uint8(im))

set(gca','ytick',[],'xtick',[])
axes('units','centimeters','pos',[ 2.5 h/2-1  pSize])
image(uint8(im2))
s = caxis;
set(gca','ytick',[],'xtick',[])


pos = [5 h-6] ;
for i = 1:3
    axes('units','centimeters','pos',[ pos 2 2])
    %imshow(im2(:,:,i),[])
    image(uint8(im2(:,:,i)))
    caxis(s)
    set(gca','ytick',[],'xtick',[])
    pos = pos - [0 2.1];
end

pos = [7.5 h-2] ;
for i = 1:7   
    axes('units','centimeters','pos',[ pos 2 2])
    imagesc(uint8(res(2).x(:,:,i)))
  colormap gray
    set(gca','ytick',[],'xtick',[])
    pos = pos - [0 2.1];
end

pos = [10 h-2] ;
for i = 1:7   
    axes('units','centimeters','pos',[ pos 2 2])
    imagesc(uint8(res(3).x(:,:,i)))
  colormap gray
    set(gca','ytick',[],'xtick',[])
    pos = pos - [0 2.1];
end

[row,col,vol,~] =size(res(4).x)
pSize = [row col]/16;
pos = [12.5 h-2] ;
for i = 1:7   
    axes('units','centimeters','pos',[ pos pSize])
    imagesc(uint8(res(4).x(:,:,i)))
  colormap gray
    set(gca','ytick',[],'xtick',[])
    pos = pos - [0 2.1];
end


b = exp(res(end-1).x)./sum(exp(res(end-1).x));
b(:)
imdb.meta.classes
[~,p] = sort(res(end-1).x, 3, 'descend') ;
imdb.meta.classes(p(1))