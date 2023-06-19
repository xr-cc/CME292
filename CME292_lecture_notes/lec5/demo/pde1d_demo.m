% 1-D PDE demo

%% select the solution mesh
x = linspace(0,1,30);
t = linspace(0,2,10);

%% solve equation
m = 0;
sol = pdepe(m,@pde_eq,@pde_ic,@pde_bc,x,t);

%% plot solution
u = sol(:,:,1); % extract the solution
figure('Position', [100,100,800,300]);
subplot(1,2,1);
surf(x,t,u)
title('Numerical solution')
xlabel('Distance x')
ylabel('Time t')

subplot(1,2,2);
surf(x,t,exp(-t)'*sin(pi*x))
title('Analytical solution')
xlabel('Distance x')
ylabel('Time t')

%% code the equation
function [c,f,s] = pde_eq(x,t,u,dudx)
c = pi^2;
f = dudx;
s = 0;
end

%% code the initial condition
function u0 = pde_ic(x)
u0 = sin(pi*x);
end

%% code the boundary conditions
function [pl,ql,pr,qr] = pde_bc(xl,ul,xr,ur,t)
pl = ul;
ql = 0;
pr = pi * exp(-t);
qr = 1;
end
