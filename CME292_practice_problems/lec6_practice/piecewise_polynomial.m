classdef piecewise_polynomial
    %PIECEWISE_POLYNOMIAL  Class for handling polynomials and operations
    
    properties (GetAccess=public,SetAccess=private)
        npoly =[];
        polys =[];
        xi    =[];
    end
    
    methods
        function  self = piecewise_polynomial(arg1,arg2)
            
            if nargin == 0
                return;
            end
            
            if nargin == 1
                % If there is only one input and it is a piecewise_polynomial 
                % object, simply copy the properties
                if strcmpi(class(arg1),'piecewise_polynomial')
                    all_props = properties('piecewise_polynomial')';
                    for prop = all_props
                        self.(prop{1}) = arg1.(prop{1});
                    end
                    return;
                elseif strcmpi(class(arg1),'double')
                    % If there is only one input and it is a double array,
                    % set xi and npoly
                    self.xi = arg1;
                    self.npoly = length(self.xi)-1;
                    p(self.npoly) = polynomial();
                    self.polys = p;
                end
            elseif nargin == 2
                % If there are two arguments, assume arg1 = xi and arg2 =
                % polys
                self.xi = arg1;
                self.npoly = length(arg1)-1;
                self.polys = arg2;
            end
            
            if length(self.polys) ~= self.npoly
                error('length(polys) must equal npoly');
            end
            
        end
        
        function  [pp1_union,pp2_union] = union_knots(pp1,pp2)
            % This function introduces knots into pp1 and pp2 such that
            % pp1_union and pp2_union have the SAME KNOTS without changing
            % the polynomial.
            
            % Determine the union of knots in pp1, pp2 (discard repeats).
            % This will be the number of knots in the resulting piecewise
            % polynomials.
            l_xi = unique([pp1.xi,pp2.xi]);
            l_npoly = length(l_xi)-1;
            
            % Reformulate polynomials with additional knots
            pp1_union = piecewise_polynomial(l_xi);
            pp2_union = piecewise_polynomial(l_xi);
            for i = 1:l_npoly
                ind1 = find(pp1.xi <= l_xi(i),1,'last');
                pp1_union.polys(i) = pp1.polys(ind1);
                
                ind2 = find(pp2.xi <= l_xi(i),1,'last');
                pp2_union.polys(i) = pp2.polys(ind2);
            end
        end
        
        function  [pp] = apply_operator_all_poly(op,pp1,pp2)
            % Apply binary or unary operator (op) to all polynomials in the
            % piecewise_polynomial pp1 and pp2 (if binary).  Binary
            % operations require pp1 and pp2 to have same knots.
            
            % If applying binary operator (+,-,*,etc) make sure the knots
            % match up before applying operators to the matching polynomials.
            if nargin == 3
                if ~((pp1.npoly == pp2.npoly) && (norm(pp1.xi - pp2.xi)==0))
                    error('Knots must match to perform operation on all polynomials');
                end
            end
            
            % Create new polynomial and apply operator (op is a function
            % handle)
            pp = piecewise_polynomial(pp1.xi);
            for i = 1:pp.npoly
                if nargin == 2
                    pp.polys(i) = op(pp1.polys(i));
                elseif nargin == 3
                    pp.polys(i) = op(pp1.polys(i),pp2.polys(i));
                end
            end
        end
        
        function  pp = uplus(pp1)
            pp = apply_operator_all_poly(@uplus,pp1);
        end
        
        function  pp = plus(pp1,pp2)
            [pp1_union,pp2_union] = union_knots(pp1,pp2);
            pp = apply_operator_all_poly(@plus,pp1_union,pp2_union);
        end
        
        function  pp = uminus(pp1)
            pp = apply_operator_all_poly(@uminus,pp1);
        end
        
        function  pp = minus(pp1,pp2)
            [pp1_union,pp2_union] = union_knots(pp1,pp2);
            pp = apply_operator_all_poly(@minus,pp1_union,pp2_union);
        end
        
        function  pp = mtimes(pp1,pp2)
            [pp1_union,pp2_union] = union_knots(pp1,pp2);
            pp = apply_operator_all_poly(@mtimes,pp1_union,pp2_union);
        end
        
        function  pp = mpower(pp1,b)
            pp = piecewise_polynomial(pp1);
            for i = 1:pp.npoly
                pp.polys(i) = pp.polys(i)^b;
            end
        end
        
        function  iseq = eq(pp1,pp2)
            [pp1_union,pp2_union] = union_knots(pp1,pp2);
            iseq = true;
            for i = 1:length(pp1_union)
                iseq = (iseq && iseq(pp1_union(i),pp2_union(i)));
            end
        end
        
        function  isz = iszero(pp)
            isz = true;
            for i = 1:length(pp)
                isz = (isz && iszero(pp.polys(i)));
            end
        end
        
        function  pp = integrate(pp1,const)
            pp = apply_operator_all_poly(@(p) integrate(p,const),pp1);
        end
        
        function  pp = differentiate(pp1)
            pp = apply_operator_all_poly(@differentiate,pp1);
        end
                
        function  [y] = evaluate(pp,x)
            y = zeros(size(x));
            for i = 1:length(pp.polys)
                xx = x( x >= pp.xi(i) & x <= pp.xi(i+1));
                y( x >= pp.xi(i) & x <= pp.xi(i+1) ) = evaluate(pp.polys(i),xx);
            end
        end
        
        function  ax = plot_it(pp,x,pstr,ax)
            
            if nargin < 4, fig=figure(); ax = axes(); end;
            set(ax,'nextplot','add');
            for i = 1:length(pp.polys)
                xx = x( x >= pp.xi(i) & x <= pp.xi(i+1));
                plot_it(pp.polys(i),xx,pstr,ax);
            end
            
        end
    end
end