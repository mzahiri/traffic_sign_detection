imdb = load('data/cifar-baseline/imdb.mat');
load 'data/cifar-baseline/net-epoch-20.mat'
%%
imN = 151;

im2 = imdb.images.data(:,:,:,imN) ;
labels = 5;%imdb.images.labels(1,imN) ;

net.layers{end}.class = 1;%imdb.images.labels(1,imN) ;196,297
res = vl_simplenn(net, im2);


im = res(1).x+ imdb.images.data_mean;
imshow(uint8(im),[])


b = exp(res(end-1).x)./sum(exp(res(end-1).x));
b(:)
imdb.meta.classes
[~,p] = sort(res(end-1).x, 3, 'descend') ;
imdb.meta.classes(p(1))