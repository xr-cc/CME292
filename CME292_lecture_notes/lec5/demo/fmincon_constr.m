function  [c,ceq,dc,dceq] = fmincon_constr_soln(x)

c   = x(1)^2+x(2)^2-2;
ceq = [];
dc   = [2*x(1),2*x(2)]';
dceq = [];

end