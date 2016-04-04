p=net.layers{1,1}.filters;
b=net.layers{1,1}.biases;


for i=1:32
    
    r(:,:,1:3)=p(:,:,1:3,i);
    r=r+b(i);
    
    for j=1:3
    An(:,:,j) = (r(:,:,j) - min(min(r(:,:,j))))/(max(max(r(:,:,j))) - min(min(r(:,:,j))));
    end
    An=255.*An;
    subplot('Position',[(mod(i-1,8))/8 1-(ceil(i/8))/8 1/8 1/8])
    imshow(uint8(An))
end

p = get(gcf,'Position');
k = [size((An),2) size(An,1)]/(size((An),2)+size((An),1));
set(gcf,'Position',[p(1) p(2) (p(3)+p(4)).*k]) 