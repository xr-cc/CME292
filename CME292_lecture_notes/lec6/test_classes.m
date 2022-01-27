%% Test element hande class by reference
e1 = element;
e2 = e1
e1.elementType = 'Rectangle'
e2.elementType
delete(e1)
e2

%% Test polynomial class
poly(1) = polynomial([0,1]);
poly(2) = polynomial([0,0,1]);
poly(3) = polynomial([0,0,0,1]);
poly(4) = polynomial(0);

ax=axes('nextplot','add');
for i = 1:length(poly)
    ipoly(i) = integrate(poly(i),0);
    dpoly(i) = differentiate(poly(i));
    ppoly(i) = poly(i)^2;
    uppoly(i)= +poly(i);
    umpoly(i)= -poly(i);
    eval0(i) = evaluate(poly(i),0);
    zpoly(i)= iszero(poly(i));
    for j = 1:length(poly)
        apoly(i,j) = poly(i) + poly(j);
        mpoly(i,j) = poly(i) - poly(j);
        tpoly(i,j) = poly(i)*poly(j);
    end
    plot_it(poly(i),linspace(-1,1,100),{'r--','linewi',2},ax);
end

%% Test piecewise polynomial class
poly(1) = polynomial([0,1]);
poly(2) = polynomial([-3,0,1]);
poly(3) = polynomial([0,0,-2,1]);
poly(4) = polynomial(0);

pp1 = piecewise_polynomial([-2,-1,2],[poly(3),poly(4)]);
pp2 = piecewise_polynomial([-2,-1,1,2],[poly(4),poly(1),poly(4)]);
pp3 = piecewise_polynomial([-2,1,2],[poly(4),poly(2)]);

x = linspace(-2,2,1000);
ax=plot_it(pp1,x,{'r-','linew',2});
plot_it(pp2,x,{'b-','linew',2},ax);
plot_it(pp3,x,{'k--','linew',2},ax);


pp_add = +pp1 + pp2 + pp3; plot_it(pp_add,x,{'k-','linew',2}); % Test uplus and plus
pp_min =  pp1 - pp2 - pp3; plot_it(pp_min,x,{'k-','linew',2}); % Test uminus and minus
pp_tim = (pp1+pp2+pp3)*(pp1-pp2-pp3); plot_it(pp_tim,x,{'k-','linew',2}); % Test mtimes
pp_pow = pp2^3; plot_it(pp_pow,x,{'k-','linew',2}); % Test power
pp_int = integrate(pp_add,0); plot_it(pp_int,x,{'k-','linew',2}); % Test integrate
pp_dif = differentiate(pp_int); plot_it(pp_dif,x,{'k-','linew',2}); % Test differentiate
iszero(pp_add - pp_dif)

% y = evaluate(pp_int,x);