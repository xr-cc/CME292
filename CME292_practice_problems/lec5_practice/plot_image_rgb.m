function  [] = plot_image_rgb(RGB,axHan)

if nargin < 4, axHan=gca; end

m = size(RGB,1)/3; n = size(RGB,2);
A = zeros(m,n,3);
A(:,:,1)=RGB(1:m,:);
A(:,:,2)=RGB(m+1:2*m,:);
A(:,:,3)=RGB(2*m+1:end,:);
image(uint8(A),'Parent',axHan);

end