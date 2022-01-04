function [b,varargout] = vararg_ex(a,varargin)
    b = a^2;
    varargout = cell(length(varargin)-a,1);
    [varargout{:}] = varargin{1:end-a};
end