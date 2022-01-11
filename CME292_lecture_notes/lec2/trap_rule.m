function int_f = trap_rule(f,a,b,nel)

x=linspace(a,b,nel+1)';
int_f=0.5*((b-a)/nel)*sum(f(x(1:end-1))+f(x(2:end)));

end