function  [s,dsdA] = compute_stress(U,dUdA,msh,mat)

[N,dNdA] = compute_internal_force(U,dUdA,msh,mat);
s    = N./mat.A;
dsdA = bsxfun(@times,1./mat.A,dNdA) - diag(N./mat.A./mat.A);

end