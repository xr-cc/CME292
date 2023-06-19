function [f,df] = fsolve_func(x)

f  = [x(1)-4*x(1)^2-x(1)*x(2);...
      2*x(2)-x(2)^2-3*x(1)*x(2)];
df = [1-8*x(1)-x(2),-x(1);...
      -3*x(2),2-2*x(2)-3*x(1)];

end