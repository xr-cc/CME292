function  [err,df,df_fd] = checkJacWithFD(W,msh,bcs,mat)


eps = 1e-6;

[~,df] = staticResidual(W,X,LM,ubc,Up,Fp,k,ndof,nel);

df_fd = zeros(size(df));

n=length(W);
for i = 1:n
    ei=canonicalbase(i,n);
    fp = staticResidual(W+eps*ei,X,LM,ubc,Up,Fp,k,ndof,nel);
    fm = staticResidual(W-eps*ei,X,LM,ubc,Up,Fp,k,ndof,nel);
    
    df_fd(:,i) = (1/(2*eps))*(fp-fm);
end

err = norm(df-df_fd,'fro')/norm(df_fd,'fro');




end

function  [ei] = canonicalbase(i,n)

ei=zeros(n,1);
ei(i)=1;

end