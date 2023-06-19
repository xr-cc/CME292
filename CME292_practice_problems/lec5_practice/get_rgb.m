function  [RGB] = get_rgb(fname)

% Parse filename to determine extension
if isempty(find(fname=='.',1))
    error('Filename must include extension.');
else
    ext = fname(find(fname=='.',1,'last')+1:end);
end

A = double(imread(fname,ext));
RGB = [A(:,:,1);A(:,:,2);A(:,:,3)];

end