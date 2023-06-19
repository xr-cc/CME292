function  [W,dWdA] = compute_weight(U,dUdA,msh,mat)

[l,dldA] = compute_element_lengths(U,dUdA,msh);

W    = mat.density*(l'*mat.A);
dWdA = mat.density*(l' + mat.A'*dldA)';

end