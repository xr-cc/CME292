classdef  element < handle
    properties (SetAccess=private, GetAccess=public)
        nsd    = 2; % number of spatial dimensions (default=2)
        nedges = 3; % number of edges in element (default=3; triangle in 2D)
        nodes  = []; 
    end
    
    properties
        elementType = 'Triangle'
    end
    
    methods
        % My constructor
        function  [self] = element()
            self.nodes = zeros(self.nsd,self.nedges);
        end
        
        function  [q] = quadrature(w,x)
            for i = 1:length(x)  
                q = q + w(i)*x(:,i);
            end
        end
    end
end