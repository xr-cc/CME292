classdef polynomial_solution
    %POLYNOMIAL_SOLUTION  Class for handling polynomials and operations
    
    properties (GetAccess=public,SetAccess=private)
        coeffs=[];
        order =0;
    end
    
    methods
        function  self = polynomial_solution(arg1)
            
            % Return empty if no arguments
            if nargin == 0
                return;
            end
            
            % Copy constructor if arg1 polynomial
            if isa(arg1,'polynomial_solution')
                self.coeffs = arg1.coeffs;
                self.order  = arg1.order;
                return;
            end
            
            % Otherwise, arg1 is coeffs vector
            lastnnz = find(arg1 ~= 0,1,'last');
            if isempty(lastnnz), lastnnz = 1; end;
            self.coeffs = arg1(1:lastnnz);
            self.coeffs = self.coeffs(:)';
            self.order  = length(self.coeffs)-1;
            
        end
        
        function  [poly] = uplus(poly1)
            poly=poly1;
        end
        
        function  [poly3] = plus(poly1,poly2)
            
            max_order=max(poly1.order,poly2.order);
            poly3 = polynomial_solution([poly1.coeffs,zeros(1,max_order-poly1.order)] + ...
                               [poly2.coeffs,zeros(1,max_order-poly2.order)]);
            
        end
        
        function  [poly] = uminus(poly1)
            poly=polynomial_solution(-poly1.coeffs);
        end
        
        function  [poly3] = minus(poly1,poly2)
            
            max_order=max(poly1.order,poly2.order);
            poly3 = polynomial_solution([poly1.coeffs,zeros(1,max_order-poly1.order)] - ...
                               [poly2.coeffs,zeros(1,max_order-poly2.order)]);
           
        end
        
        function  [poly] = mtimes(a,b)
            
            if strcmpi(class(a),'polynomial_solution') && strcmpi(class(b),'polynomial_solution')
                poly = polynomial_solution(conv(a.coeffs,b.coeffs));
            elseif strcmpi(class(a),'polynomial_solution') && strcmpi(class(b),'double')
                poly = polynomial_solution(b*a.coeffs);
            elseif strcmpi(class(b),'polynomial_solution') && strcmpi(class(a),'double')
                poly = polynomial_solution(a*b.coeffs);
            end
            
        end
        
        function  [poly] = mpower(poly1,b)
            
            if b == 0
                poly = polynomial_solution(1);
                return;
            elseif b == 1
                poly = poly1;
                return;
            end
            
            if ~(isa(poly1,'polynomial_solution') && isa(b,'double') && b >= 0 && round(b) == b)
                error('mpower requires polynomial_solution and integer');
            end
            poly = polynomial_solution(poly1);
            for i = 1:b-1
                poly = poly*poly1;
            end
            
        end
            
        function  [iseq] = eq(poly1,poly2)
            if poly1.order < poly2.order
                coeffs1=[poly1.coeffs,zeros(1,length(poly2.coeffs)-length(poly1.coeffs))];
                coeffs2=poly2.coeffs;
            else
                coeffs1=poly1.coeffs;
                coeffs2=[poly2.coeffs,zeros(1,length(poly1.coeffs)-length(poly2.coeffs))];
            end
            iseq = all(coeffs1 == coeffs2);
        end
        
        function  [tf] = iszero(poly)
            
            tf = all(poly.coeffs == 0);
            
        end
        
        function  [poly1] = integrate(poly,const)
            
            if nargin < 2
                c=0;
            else
                c = const;
            end;
            factors = [c,1./(1:poly.order+1)];
            poly1   = polynomial_solution(factors.*[1,poly.coeffs]); %degree N+1 polynomial
            
        end
        
        function  [ax] = plot_it(poly,x,pstr,ax)
            
            if nargin<4, figure(); ax=gca; end;
            plot(ax,x,poly.evaluate(x),pstr{:});
            
        end
        
        function [] = disp(poly)
            
            for i = 1:poly.order+1
                if i == 1
                    fprintf('%5.4f',poly.coeffs(i));
                elseif i == 2
                    fprintf(' + %5.4f x',poly.coeffs(i));
                else
                    fprintf(' + %5.4f x^%i',poly.coeffs(i),i-1);
                end
            end
            fprintf('\n');
            
        end
        
        function  [poly1] = differentiate(poly)
            
            if iszero(poly), poly1=poly; return; end;
            if (length(poly.coeffs) == 1)
                poly1 = poly;
                poly1.coeffs = 0 * poly.coeffs; 
                return;
            end
            
            factors = 1:poly.order;
            poly1   = polynomial_solution(factors.*poly.coeffs(2:end));
            
        end
        
        function  [y] = evaluate(poly,x)
            y = polyval(fliplr(poly.coeffs),x);
        end
    end
end