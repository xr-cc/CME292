function  [err_dUdA,err_dFdA,err_dWdA,err_dsdA,err_dNdA,err_dCdA,err_dldA,err_dudA] = checkDerivWithFd(nel)

eps = 1.0e-6;

A = rand(nel,1);
[msh,bcs,mat] = setup_problem(A);
U = rand(msh.ndof,1);

% % Check element length derivatives
% [~,dldU] = compute_element_lengths(U,msh);
% dldU_fd = zeros(size(dldU));
% for i = 1:msh.ndof
%     ei=canonicalbase(i,msh.ndof);
%     lp = compute_element_lengths(U+eps*ei,msh);
%     lm = compute_element_lengths(U-eps*ei,msh);
% 
%     dldU_fd(:,i) = (1/(2*eps))*(lp - lm);
% end
% err_dldU = norm(dldU - dldU_fd,'fro')/norm(dldU_fd,'fro');

% Check displacement/force derivatives
[msh,bcs,mat] = setup_problem(A);
[~,dUdA,~,dFdA] = solve_truss(msh,mat,bcs);
dUdA_fd = zeros(size(dUdA));
dFdA_fd = zeros(size(dFdA));
for i = 1:msh.nel
    ei=canonicalbase(i,msh.nel);
    
    [msh,bcs,mat] = setup_problem(A+eps*ei);
    [Up,~,Fp,~] = solve_truss(msh,mat,bcs);
    
    [msh,bcs,mat] = setup_problem(A-eps*ei);
    [Um,~,Fm,~] = solve_truss(msh,mat,bcs);
    
    dUdA_fd(:,i) = (1/(2*eps))*(Up - Um);
    dFdA_fd(:,i) = (1/(2*eps))*(Fp - Fm);
end
err_dUdA = norm(dUdA - dUdA_fd,'fro')/norm(dUdA_fd,'fro');
err_dFdA = norm(dFdA - dFdA_fd,'fro')/norm(dFdA_fd,'fro');

% Check stress and weight derivatives
[msh,bcs,mat] = setup_problem(A);
[U,dUdA,F,dFdA] = solve_truss(msh,mat,bcs); % We know dUdA is good!
[~,dWdA] = compute_weight(U,dUdA,msh,mat);
[~,dsdA] = compute_stress(U,dUdA,msh,mat);
[~,dNdA] = compute_internal_force(U,dUdA,msh,mat);
[~,dCdA] = compute_compliance(U,dUdA,F,dFdA);
[~,dldA] = compute_element_lengths(U,dUdA,msh);
[~,dudA] = compute_displacement(U,dUdA,1:msh.nn);

dWdA_fd = zeros(size(dWdA));
dsdA_fd = zeros(size(dsdA));
dNdA_fd = zeros(size(dNdA));
dCdA_fd = zeros(size(dCdA));
dldA_fd = zeros(size(dldA));
dudA_fd = zeros(size(dudA));
for i = 1:msh.nel
    ei=canonicalbase(i,msh.nel);
    
    [msh,bcs,mat] = setup_problem(A+eps*ei);
    [U,dUdA,F,dFdA] = solve_truss(msh,mat,bcs); % We know dUdA is good!
    Wp = compute_weight(U,dUdA,msh,mat);
    sp = compute_stress(U,dUdA,msh,mat);
    Np = compute_internal_force(U,dUdA,msh,mat);
    Cp = compute_compliance(U,dUdA,F,dFdA);
    lp = compute_element_lengths(U,dUdA,msh);
    up = compute_displacement(U,dUdA,1:msh.nn);

    [msh,bcs,mat] = setup_problem(A-eps*ei);
    [U,dUdA] = solve_truss(msh,mat,bcs); % We know dUdA is good!
    Wm = compute_weight(U,dUdA,msh,mat);
    sm = compute_stress(U,dUdA,msh,mat);
    Nm = compute_internal_force(U,dUdA,msh,mat);
    Cm = compute_compliance(U,dUdA,F,dFdA);
    lm = compute_element_lengths(U,dUdA,msh);
    um = compute_displacement(U,dUdA,1:msh.nn);
    
    dWdA_fd(i) = (1/(2*eps))*(Wp - Wm);
    dsdA_fd(:,i) = (1/(2*eps))*(sp - sm);
    dNdA_fd(:,i) = (1/(2*eps))*(Np - Nm);
    dCdA_fd(i) = (1/(2*eps))*(Cp - Cm);
    dldA_fd(:,i) = (1/(2*eps))*(lp - lm);
    dudA_fd(:,i) = (1/(2*eps))*(up - um);
end
err_dWdA = norm(dWdA - dWdA_fd,'fro')/norm(dWdA_fd,'fro');
err_dsdA = norm(dsdA - dsdA_fd,'fro')/norm(dsdA_fd,'fro');
err_dNdA = norm(dNdA - dNdA_fd,'fro')/norm(dNdA_fd,'fro');
err_dCdA = norm(dCdA - dCdA_fd,'fro')/norm(dCdA_fd,'fro');
err_dldA = norm(dldA - dldA_fd,'fro')/norm(dldA_fd,'fro');
err_dudA = norm(dudA - dudA_fd,'fro')/norm(dudA_fd,'fro');

end


function  [ei] = canonicalbase(i,n)

ei=zeros(n,1);
ei(i)=1;

end