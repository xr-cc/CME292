% profiler example

addpath('nltruss/');

profile on;

mesh = 'mesh2';
[nel,nodes,conn,bc] = eval([mesh,'()']);
A0 = 0.1*ones(nel,1);
[msh,bcs,mat] = setup_problem(A0,mesh);

[U0,dUdA,F0,dFdA] = solve_truss(msh,mat,bcs);
W0 = compute_weight(U0,dUdA,msh,mat);
s0 = compute_stress(U0,dUdA,msh,mat);
C0 = compute_compliance(U0,dUdA,F0,dFdA);

profile viewer;

visualize_truss_loads(msh,bcs,mat,U0,10);

profsave