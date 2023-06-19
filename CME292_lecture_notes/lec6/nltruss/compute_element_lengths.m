function  [l,dldA] = compute_element_lengths(U,dUdA,msh)

%Determine internal forces
x = msh.node + U(msh.ID');%U;
l=zeros(msh.nel,1); dldU=zeros(msh.nel,msh.ndof);
for e = 1:msh.nel
    l(e) = sqrt((x(msh.conn(2,e),1)-x(msh.conn(1,e),1))^2 + ...
        (x(msh.conn(2,e),2)-x(msh.conn(1,e),2))^2);
    
    dldU(e,msh.LM(1,e)) = -(x(msh.conn(2,e),1)-x(msh.conn(1,e),1))/l(e);
    dldU(e,msh.LM(2,e)) = -(x(msh.conn(2,e),2)-x(msh.conn(1,e),2))/l(e);
    dldU(e,msh.LM(3,e)) = (x(msh.conn(2,e),1)-x(msh.conn(1,e),1))/l(e);
    dldU(e,msh.LM(4,e)) = (x(msh.conn(2,e),2)-x(msh.conn(1,e),2))/l(e);
end 
dldA = dldU*dUdA;

end