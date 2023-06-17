function [b,varargout] = vararg_ex(a,varargin)
    b = a^2;
    varargout = cell(1,length(varargin));
    [varargout{:}] = varargin{:};
end