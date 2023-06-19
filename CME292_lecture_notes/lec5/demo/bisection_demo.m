function  x_half = bisection_demo(f,xlim)

% Bisection method
x = linspace(xlim(1),xlim(2),1000);
ylim = [min(f(x)),max(f(x))];
ylim = ylim + 0.1*diff(ylim)*[-1,1];

% Plot function
figure(); axes(); title(func2str(f)); hold on;
plot(x,f(x),'k-','linew',2);
plot(x,0*x,'k--'); plot([0,0],ylim,'k--');
set(gca,'xlim',xlim,'ylim',ylim);
fprintf('Press any key to continue\n'); pause;

a = xlim(1); b = xlim(2);
if f(a)*f(b) > 0, error('Endpoints have the same sign!'); end;
% Plot circle at current interval extents
obj=plot([a,b],[f(a),f(b)],'ko','markerfacecolor','b');
fprintf('Press any key to continue\n'); pause;
for i = 1:100
    % Bisect
    x_half = 0.5*(b+a);
    if f(x_half)*f(a) > 0
        a = x_half;
    elseif f(x_half)*f(b) > 0
        b = x_half;
    end
    
    % Plot new point
    newobj1 = plot(x_half,f(x_half),'ko','markerfacecolor','r');
    newobj2 = plot([x_half,x_half],ylim,'r--');
    fprintf('Press any key to continue\n'); pause;
    
    % Plot new interval
    delete(newobj1); delete(newobj2);
    set(obj,'markerfacecolor','w');
    obj=plot([a,b],[f(a),f(b)],'ko','markerfacecolor','b');
    fprintf('Press any key to continue\n'); pause;
    
    if abs(f(x_half)) < 1e-3
        fprintf('Converged!\n'); break;
    end
end
end