function  [] = visualize_truss_loads(msh,bcs,mat,U,scale)

if nargin < 4
    U = zeros(msh.ndof,1);
    scale=1;
end

if size(U,1) == msh.ndof
    W = U;
    U=zeros(msh.ndof,1);
    U(bcs.ubc) = bcs.Up(bcs.ubc);
    U(bcs.fbc) = W(bcs.fbc);
end
x = msh.node + scale*U(msh.ID');

% Plot nodes
plot(x(:,1),x(:,2),'ks'); hold on;

% Plot elements
for e = 1:msh.nel
    n1=msh.conn(1,e);
    n2=msh.conn(2,e);
    h(1)=plot(msh.node([n1;n2],1),msh.node([n1;n2],2),'k-');
    h(2)=plot(x([n1;n2],1),x([n1;n2],2),'b--');
    set(h(2),'linewidth',2*mat.A(e)/max(mat.A));
end

% Limits
xmin_undef = min(msh.node(:,1)); ymin_undef = min(msh.node(:,2));
xmax_undef = max(msh.node(:,1)); ymax_undef = max(msh.node(:,2));

xmin = min([x(:,1);msh.node(:,1)]); ymin = min([x(:,2);msh.node(:,2)]);
xmax = max([x(:,1);msh.node(:,1)]); ymax = max([x(:,2);msh.node(:,2)]);
dx = xmax-xmin; dy = ymax-ymin;
dist_to_def_y = max(abs([ymin-ymin_undef,ymax-ymax_undef]));
axis equal;
set(gca,'xlim',[xmin_undef-0.1*dx,xmax_undef+0.1*dx],'ylim',[ymin_undef-dist_to_def_y-0.5*dy,ymax_undef+dist_to_def_y+0.5*dy]);

% Plots forces
Fp = reshape(bcs.Fp,2,msh.nn);
Fp = Fp/max(sqrt(sum(Fp.^2,1)));
for i = 1:msh.nn
    quiver(x(i,1),x(i,2),Fp(1,i),Fp(2,i),0.6);
end

% Plot DBCs
ubc = reshape(bcs.ubc,2,msh.nn);
for i = 1:msh.nn
    if ubc(1,i) && ubc(1,i) % Pin
        plot_triangle_below(x(i,:));
    elseif ubc(1,i) % Left roller
        plot_circle_at(x(i,:),'left');
    elseif ubc(2,i)
        plot_circle_at(x(i,:),'below');
    end
end

end

function   [] = plot_triangle_below(x,l)

if nargin < 2
    l=0.1;
end
fill([x(1),x(1)-l,x(1)+l,x(1)],[x(2),x(2)-l,x(2)-l,x(2)],'k');

end

function   [] = plot_circle_at(x,where,l)

if nargin < 3
    l=0.1;
end

th=linspace(0,2*pi,100);
plot(l*sin(th)+x(1),l*cos(th)+x(2)-l);

end