function  [N,dNdA] = compute_internal_force(U,dUdA,msh,mat)

%Compute internal forces
[l,dldA] = compute_element_lengths(U,dUdA,msh);
N    = mat.E*mat.A.*(l./msh.L - 1);
dNdA = bsxfun(@times,mat.E*(mat.A./msh.L),dldA) + diag(mat.E*(l./msh.L - 1));
% dNdU = bsxfun(@times,(mat.E./msh.L).*mat.A,(bsxfun(@minus,dldU,msh.L)));

% %Determine internal forces
% x = msh.node + U;
% l=zeros(msh.nel,1);
% N=zeros(msh.nel,1);
% for e = 1:msh.nel
%     l(e) = sqrt((x(msh.conn(2,e),1)-x(msh.conn(1,e),1))^2 + ...
%         (x(msh.conn(2,e),2)-x(msh.conn(1,e),2))^2);
%     N(e) = mat.E*mat.A(e)*(l(e)-msh.L(e))/msh.L(e);
% end 

end