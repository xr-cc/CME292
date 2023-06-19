function  [C,dCdA] = compute_compliance(U,dUdA,F,dFdA)

C = F'*U;
dCdA = U'*dFdA + F'*dUdA;
dCdA=dCdA(:);

end