function [b,avg] = add2(a)
    b = a + 2;
    avg = average(a, length(a));
end

function b = average(a,n)
    b = sum(a)/n;
end