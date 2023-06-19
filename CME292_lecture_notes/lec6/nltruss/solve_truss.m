function  [U,dUdA,F,dFdA] = solve_truss(msh,mat,bcs)
%% Solve nonlinear system
W=zeros(msh.ndof,1);
[R,J] = staticResidual(W,msh,mat,bcs);
p = inf(msh.ndof,1);
r0 = norm(R);

nmax      = 100;
loadsteps = 1;
for i = 1:loadsteps
    mbcs = bcs;
    mbcs.Fp = (i/loadsteps)*bcs.Fp;
    for j = 1:nmax
        conv=norm(R);
        if conv < 1e-8*r0
            nnewt=j-1;
            break;
        end
        if norm(R) < 1e-8 && norm(p) < 1e-6
            nnewt=j-1;
            break;
        end
        
        W=W-J\R;
        [R,J] = staticResidual(W,msh,mat,mbcs);%X,LM,ubc,Up,Fp,k,ndof,nel);
    end
end
if j == nmax
    fprintf('WARNING...Newton iterations did not converge...\n');
end
[~,dFdW,dFdA] = staticResidual(W,msh,mat,bcs);
dUdA = -dFdW\dFdA;
dFdA = dUdA;

dUdA(bcs.ubc,:)=0;
dFdA(bcs.fbc,:)=0;

%% Construct entire displacement and force vectors
U=zeros(msh.ndof,1);
U(bcs.ubc) = bcs.Up(bcs.ubc);
U(bcs.fbc) = W(bcs.fbc);
% U = U(msh.ID');

F=zeros(msh.ndof,1);
F(bcs.ubc) = W(bcs.ubc);
F(bcs.fbc) = bcs.Fp(bcs.fbc);
% F = F(msh.ID');
end