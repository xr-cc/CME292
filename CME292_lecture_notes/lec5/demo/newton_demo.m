function  [] = newton_demo(f,df,x0,xlim)

% 1st order Taylor expansion
tay = @(x,xk) f(xk) + df(xk)*(x - xk);

% Newtons method
x = linspace(xlim(1),xlim(2),1000);
ylim = [min(f(x)),max(f(x))];
ylim = ylim + 0.1*diff(ylim)*[-1,1];

% Plot function
figure(); axes(); title(func2str(f)); hold on;
plot(x,f(x),'k-','linew',2);
plot(x,0*x,'k--'); plot([0,0],ylim,'k--');
set(gca,'xlim',xlim,'ylim',ylim);
fprintf('Press any key to continue\n'); pause;

xk = x0;
for i = 1:10
    % Plot circle at current function value
    plot(xk,f(xk),'bo');
    fprintf('Press any key to continue\n'); pause;
    
    % Plot line from Taylor expansion
    plot(x,tay(x,xk),'r-');
    fprintf('Press any key to continue\n'); pause;
    
    % Compute Newton and plot intersection of line
    xk = xk - f(xk)/df(xk);
    plot(xk,0,'ro');
    fprintf('Press any key to continue\n'); pause;
    if abs(f(xk)/f(x0)) < 1e-6 || abs(f(xk)) < 1e-8
        fprintf('Converged!\n'); break;
    end
end
end