function  [f,df,dfdA] = staticResidual(W,msh,mat,bcs)
%W contains all of the unknowns of the problem.  Some entries correspond to
%displacements and some are reaction forces.  We must take this into
%account by properly extracting element contributions.

f= zeros(msh.ndof,1);
df = zeros(msh.ndof);
if nargout == 3, dfdA = zeros(msh.ndof,msh.nel); end

Ue = zeros(4,1);
Fexte = zeros(4,1);
for e = 1:msh.nel
    Xe = msh.X(msh.LM(:,e));
    
    %Extract element contributions from prescribed forces and displacements
    Fpe = bcs.Fp(msh.LM(:,e));
    Upe = bcs.Up(msh.LM(:,e));
    
    %Determine the boundary conditions on the element level
    ubce = bcs.ubc(msh.LM(:,e));
    %Fill the element displacements from the unknowns and prescribed
    %displacements of the problem
    Ue(~ubce) = W(msh.LM(~ubce,e));
    Ue(ubce)  = Upe(ubce); 
    %Fill the element external forces from the unknowns and prescribed
    %external forces of the problem
    Fexte(ubce)  = W(msh.LM(ubce,e));
    Fexte(~ubce) = Fpe(~ubce);
    
    %Current length of the element and derivatives with respect to
    %displacement (all derivatives w.r.t. reaction forces are zero).
    l = sqrt(((Xe(3) - Xe(1)) + (Ue(3)-Ue(1)))^2 + ...
        ((Xe(4) - Xe(2)) + (Ue(4)-Ue(2)))^2);
    invl=1/l;
    dl = invl*[-((Xe(3)-Xe(1))+(Ue(3)-Ue(1)));...
               -((Xe(4)-Xe(2))+(Ue(4)-Ue(2)));...
                ((Xe(3)-Xe(1))+(Ue(3)-Ue(1)));...
                ((Xe(4)-Xe(2))+(Ue(4)-Ue(2)))];
             
    %Compute cos and sin of the angle the bar is currently making with the
    %horizontal.  Also compute derivatives.
    cosT  = ((Xe(3) - Xe(1)) + (Ue(3)-Ue(1)))/l;
    dcosT = -invl*(cosT*dl+[1;0;-1;0]);
    
    sinT  = ((Xe(4) - Xe(2)) + (Ue(4)-Ue(2)))/l;
    dsinT = -invl*(sinT*dl+[0;1;0;-1]);
    
    dsinTsinT = 2*sinT*dsinT;
    dcosTcosT = 2*cosT*dcosT;
    dsinTcosT = cosT*dsinT + sinT*dcosT;
    
    %Compute element contribution residual.  The first term is the internal
    %force and the second term is the external force.
    fe = mat.k(e)*[cosT^2*(Ue(1)-Ue(3)) + cosT*sinT*(Ue(2)-Ue(4));...
                   sinT^2*(Ue(2)-Ue(4)) + cosT*sinT*(Ue(1)-Ue(3));...
                   cosT^2*(Ue(3)-Ue(1)) + cosT*sinT*(Ue(4)-Ue(2));...
                   sinT^2*(Ue(4)-Ue(2)) + cosT*sinT*(Ue(3)-Ue(1))];
    if nargout == 3
        dfdAe = (mat.k(e)/mat.A(e))*[cosT^2*(Ue(1)-Ue(3)) + cosT*sinT*(Ue(2)-Ue(4));...
            sinT^2*(Ue(2)-Ue(4)) + cosT*sinT*(Ue(1)-Ue(3));...
            cosT^2*(Ue(3)-Ue(1)) + cosT*sinT*(Ue(4)-Ue(2));...
            sinT^2*(Ue(4)-Ue(2)) + cosT*sinT*(Ue(3)-Ue(1))];
    end
    %Compute the Jacobian as if all boundary conditions were prescribed
    %forces.  Then adjust this by zeroing out the columns corresponding to
    %dofs where displacements are described and filling the (i,i) entry of
    %that column with a -1.  Recall R = fint - fext.
    dfe = mat.k(e)*[dcosTcosT'*(Ue(1)-Ue(3))+dsinTcosT'*(Ue(2)-Ue(4));...
                    dsinTsinT'*(Ue(2)-Ue(4))+dsinTcosT'*(Ue(1)-Ue(3));...
                    dcosTcosT'*(Ue(3)-Ue(1))+dsinTcosT'*(Ue(4)-Ue(2));...
                    dsinTsinT'*(Ue(4)-Ue(2))+dsinTcosT'*(Ue(3)-Ue(1))];
    dfe = dfe + mat.k(e)*[cosT^2, sinT*cosT, -cosT^2, -sinT*cosT;...
                          cosT*sinT, sinT^2, -sinT*cosT, -sinT^2;...
                         -cosT^2, -sinT*cosT, cosT^2, sinT*cosT;...
                         -cosT*sinT, -sinT^2, sinT*cosT, sinT^2];
%     dfe(:,ubce) = 0;
%     dfe(ubce,ubce) = -eye(sum(ubce));
    
    %Add elemental contributions to global vector and matrix.
    f(msh.LM(:,e),1) = f(msh.LM(:,e),1) + fe;        
    df(msh.LM(:,e),msh.LM(:,e)) = df(msh.LM(:,e),msh.LM(:,e)) + dfe;
    if nargout == 3
        dfdA(msh.LM(:,e),e) = dfdA(msh.LM(:,e),e) + dfdAe;
    end
end

f(~bcs.ubc) = f(~bcs.ubc) - bcs.Fp(~bcs.ubc);
f(bcs.ubc)  = f(bcs.ubc)  - W(bcs.ubc);
df(:,bcs.ubc) = 0;
df(bcs.ubc,bcs.ubc) = -eye(sum(bcs.ubc));

end