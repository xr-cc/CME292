function  [f,df] = fmincon_obj_soln(x)

f  = x(1)^3 + x(2)^3;
df = [3*x(1)^2;3*x(2)^2];

end