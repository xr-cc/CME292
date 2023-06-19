function [x,y]=naca(bs,s) 
%NACA Geometry File defining the geometry of a NACA0015.

% Number of edge segments
nbs=300; 

if nargin==0
    % Required funcationality:
    % Return number of boundary segments when no input
    % arguments given
    x=nbs;
    return
end
L = 1; t = 0.15;
dx = L/(nbs/2);

% A matrix with one column for each boundary segment specified in BS.
%  Row 1 contains the start parameter value.
%  Row 2 contains the end parameter value.
%  Row 3 contains the label of the left-hand region.
%  Row 4 contains the label of the right-hand region.
dl = [linspace(-L,L-dx,nbs);...
      linspace(-L+dx,L,nbs);...
      1*ones(1,nbs/2),1*ones(1,nbs/2);...
      0*ones(1,nbs/2),0*ones(1,nbs/2)];

if nargin==1
    % Required funcationality:
    % Return dl
  x=dl(:,bs);   
  return 
end 

x=zeros(size(s)); 
y=zeros(size(s)); 
[m,n]=size(bs); 
if m==1 & n==1,   
  bs=bs*ones(size(s)); % expand bs 
elseif m~=size(s,1) | n~=size(s,2),   
  error('bs must be scalar or of same size as s'); 
end 

% Analytical upper surface
f = @(x) (t/0.2)*L*(0.2969*sqrt(x/L) - 0.1260*(x/L)-0.3516*(x/L).^2+0.2843*(x/L).^3-0.1036*(x/L).^4);

% Negative parameters: upper surface (tail to tip)
% Positive parameters: lower surface (tip to tail)
x(s<=0) = -s(s<=0); x(s>0) = s(s>0);
y(s<=0) = f(x(s<=0)); y(s>0) = -f(x(s>0));