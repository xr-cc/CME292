function  [A] = reconstruct_trunc_svd(U,s,V,k)

A = bsxfun(@times,U(:,1:k),s(1:k)')*V(:,1:k)';

end