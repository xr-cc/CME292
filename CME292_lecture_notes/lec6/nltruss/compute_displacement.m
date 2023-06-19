function  [u,dudA] = compute_displacement(U,dUdA,node_nums)

n=length(node_nums);
u = zeros(n,1);
dudA=zeros(n,size(dUdA,2));
for i = 1:n
    u(i)      = sqrt(sum(U(2*node_nums(i)-1:2*node_nums(i)).^2));
    if u(i) == 0, continue, end;
    dudA(i,:) = (1/u(i))*(U(2*node_nums(i)-1:2*node_nums(i))'*dUdA(2*node_nums(i)-1:2*node_nums(i),:));
end

end
