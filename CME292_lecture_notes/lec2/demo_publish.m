%% Numeric arrays
 % Creation
 M = reshape(linspace(11,18,8),[2,2,2])
 
 %% Linear indexing
 M(1)
 M(8)
 M(5:8)
 M([1,3,4,8])
 
 %% Indexing with arrays
 M([1,3,4,8])
 A =  [1,5,2;8,3,2;7,4,6];
 M(A)
 
 %% Component-wise indexing with arrays
 M([1,2],[2,1],[2,1])
 A1 = [2,2;2,1]; v = [2,1];
 M(A1,v,1)
 
 %% Logical indexing
 P = rand(5000);
 tic; for i = 1:10, P(P<0.5); end; toc
 tic; for i = 1:10, P(find(P<0.5)); end; toc
 
 R = rand(5);
 R(R < 0.15)'
 isequal(R(R < 0.15),R(find(R<0.15)))
 
%% Functions
 % Function handles
 a = exp(1);
 f = @(x) a*x.^2;
 trap_rule(f,-1,1,1000) % (2/3)*exp(1) = 1.8122
 
 % Anonymous functions
 f1 = @(x,y) [sin(pi*x), cos(pi*y), tan(pi*x*y)];
 f1(0.5,0.25)
 integral(@(x) exp(1)*x.^2,-1,1)
 
