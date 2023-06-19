function [qmatrix,gmatrix,hmatrix,rmatrix] = nacabound(p,e,u,time)

ne = size(e,2); % number of edges
qmatrix = zeros(1,ne);
gmatrix = qmatrix;
hmatrix = zeros(1,2*ne);
rmatrix = hmatrix;

for k = 1:ne
    x1 = p(1,e(1,k)); % x at first point in segment
    x2 = p(1,e(2,k)); % x at second point in segment
    xm = (x1 + x2)/2; % x at segment midpoint
    y1 = p(2,e(1,k)); % y at first point in segment
    y2 = p(2,e(2,k)); % y at second point in segment
    ym = (y1 + y2)/2; % y at segment midpoint
    
    if xm < 1/10
        % Before quarter chord has DBC
        hmatrix(k)    = 1;
        hmatrix(ne+k) = 1;
        rmatrix(k)    = 10;%100*time;
        rmatrix(ne+k) = 10;%-30*time;
        
        % After quarter chord is insulated
    end
end