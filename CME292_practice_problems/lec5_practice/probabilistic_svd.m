function [U,S,V] = probabilistic_svd(A,k,q)

% Defaults
if nargin < 2, k = 20; end
if nargin < 3, q = 0;  end
    
% Gaussian Random Matrix
Omega = randn(size(A,2),k);
% Power iteration
Y = A*Omega;
for i = 1:q
    Y = A*(A'*Y);
end
[Q,~] = qr(Y,0);   % Orthogonalization
B = Q'*A;          % Projections
[tU,S,V]=svd(B,0); % SVD
U = Q*tU;          % Reconstruction

end