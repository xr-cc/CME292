function  [U,s,V] = decompose_image_svd(fname,options)

% Defaults
if nargin < 2, options.type = 'classic'; end;

% Read image
[RGB] = get_rgb(fname);

% Compute SVD
switch options.type
    case 'classic'
        [U,s,V] = svd(RGB,0);
    case 'probabilistic'
        [U,s,V] = probabilistic_svd(RGB,options.rank,options.power);
end

% Only store vector of singular values (don't store entire matrix since it
% is mostly zeros)
s = diag(s);

end