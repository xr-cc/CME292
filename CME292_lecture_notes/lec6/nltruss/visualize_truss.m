function  [] = visualize_truss(U,msh,mat,scale)

x = msh.node + scale*U(msh.ID');
plot(msh.node(:,1),msh.node(:,2),'ks'); hold on;
plot(x(:,1),x(:,2),'bs');
for e = 1:msh.nel
    n1=msh.conn(1,e);
    n2=msh.conn(2,e);
    h(1)=plot(msh.node([n1;n2],1),msh.node([n1;n2],2),'k-');
    h(2)=plot(x([n1;n2],1),x([n1;n2],2),'b--');
    set(h,'linewidth',2*mat.A(e)/max(mat.A));
end
set(gca,'xlim',[-1,9],'ylim',[-1,6]);
axis equal;

end