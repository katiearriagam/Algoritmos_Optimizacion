%function output = HS(handleFunc,bounds,maxIter,HMCR,PAR,BW,harmMem)
%   
%   ejemplo de llamada:
%
%   HS(handle,[[10,10];[-10,-10]], 100, 0.75, 0.2, 1, 5)
%
%   ejemplo de handle:
%   
%   handle = @(x) x(1)^2 + x(2)^2
%   
%   ejemplo de bounds:
%          x1  x2
%   max: | 10  10 |
%   min: |-10 -10 | 
%  

function output = HS(handleFunc,bounds,maxIter,HMCR,PAR,BW,harmMem)
    %cantidad de dimensiones por particula
    dim = size(bounds,2);
   
    for i=1:dim
        X(:,i) = ((bounds(1,i) - bounds(2,i)) * rand(harmMem,1)) + bounds(2,i); 
    end
    
    for i=1:harmMem
        fHM(i) = handleFunc(X(i,:));
    end
    disp("Valores Iniciales:");
    disp("------------------");
    disp("HM:");
    disp(X);
    disp("fHM:");
    disp(fHM);
    disp("------------------");

    
    for i = 1:maxIter
        Xaux=[];
        for j = 1:dim
            if rand() <=HMCR
                temp = floor(dim*rand()+1);
                Xtemp = X(temp,j);
                if rand()<= PAR
                    Xtemp = Xtemp + BW*((2)*rand()-1);
                end
            else
                Xtemp = (bounds(1,j) - bounds(2,j))* rand() + bounds(2,j);
            end
            Xaux = [Xaux Xtemp];
        end
        fHMaux = handleFunc(Xaux);
        [Value,position] = max(fHM);
        
        if fHMaux<Value
            X(position,:) = Xaux;
            fHM(position) = fHMaux;
        end
        disp("Iteracion #"+i +" :");
        disp("------------------");
        disp("HM:");
        disp(X);
        disp("fHM:");
        disp(fHM);
        disp("------------------");
    end
    [Val, position] = min(fHM);
    
    output = struct(...
        'solution', X(position,:) ,...
        'fitness', Val );
    
end