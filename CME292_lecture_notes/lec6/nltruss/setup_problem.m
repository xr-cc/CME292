function  [msh,bcs,mat] = setup_problem(A,mesh)
%% Create mesh
[~,msh.node,msh.conn,bcs.bc]=eval([mesh,'()']);

msh.nn  = size(msh.node,1);
msh.ndof = 2*msh.nn; %solving for reactions too so no need to reduce ndofs
msh.nel = size(msh.conn,2);

msh.ID = reshape(1:msh.ndof,2,msh.nn);
msh.LM = [msh.ID(:,msh.conn(1,:));msh.ID(:,msh.conn(2,:))];
msh.X = reshape(msh.node',msh.ndof,1);
msh.L = zeros(msh.nel,1);
for e = 1:msh.nel
    msh.L(e) = sqrt((msh.node(msh.conn(2,e),1)-msh.node(msh.conn(1,e),1))^2 + ...
        (msh.node(msh.conn(2,e),2)-msh.node(msh.conn(1,e),2))^2);
end
%% Boundary conditions
%Extract prescribed forces (in usable form), if 
bcs.Fp = nan(msh.ndof,1);
bcs.fbc  = (bcs.bc(:,:,1) ~= 0)'; bcs.fbc = bcs.fbc(:);
fval = reshape(bcs.bc(:,:,2)',msh.ndof,1);
bcs.Fp(bcs.fbc) = fval(bcs.fbc);

%Extract prescribed displacements
bcs.ubc=~bcs.fbc;
bcs.Up = nan(msh.ndof,1);
uval = reshape(bcs.bc(:,:,2)',msh.ndof,1);
bcs.Up(bcs.ubc) = uval(bcs.ubc);

%% Material (steel)
mat.fail_stress = 500e6;
mat.density = 7850;
mat.E = 200e9;
mat.A = A; if length(A)==1, mat.A=A*ones(nel,1); end;
mat.k = zeros(msh.nel,1);
for e = 1:msh.nel
    mat.k(e) = mat.E*mat.A(e)/msh.L(e);
end
end