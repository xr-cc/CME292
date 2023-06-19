% Select mesh
mesh = 'mesh3';

% optimize_truss
[nel,nodes,conn,bc] = eval([mesh,'()']);
A0 = 0.1*ones(nel,1);
Al = 0.01*ones(nel,1);
Au = 1*ones(nel,1);

% Initial Guess
[msh,bcs,mat] = setup_problem(A0,mesh);
[U0,dUdA,F0,dFdA] = solve_truss(msh,mat,bcs);

figure;
visualize_truss_loads(msh,bcs,mat,U0,1);