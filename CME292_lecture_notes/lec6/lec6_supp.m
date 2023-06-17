%%
A = rand(10000);
tic; b=delayed_copy_ex1(A); toc
tic; b=delayed_copy_ex2(A); toc
%%
format debug
A = rand(2);
disp(A)
delayed_copy_ex3(A);
%%
function b = delayed_copy_ex1(A)
    b = 10*A(1,1);
end
function b = delayed_copy_ex2(A)
    A(1,1) = 5; 
    b = 10*A(1,1);
end
function b = delayed_copy_ex3(A)
    b = 10*A(1,1); disp(A); A(1,1) = 5; disp(A);
end