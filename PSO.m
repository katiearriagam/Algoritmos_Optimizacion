%function output = PSO(handleFunc,bounds,maxIter,c1,c2,omega,numPart)
%   
%   ejemplo de llamada:
%
%   PSO(handle,[[10,10];[-10,-10]], 100, 2, 2, .7, 50)
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

function output = PSO(handleFunc,bounds,maxIter,c1,c2,omega,numPart)

%cantidad de dimensiones por particula
dim = size(bounds,2);

%Init Posiciones
for i=1:dim
    X(:,i) = ((bounds(1,i) - bounds(2,i)) * rand(numPart,1)) + bounds(2,i); 
end
disp(X);
%Init Velocidades
V = zeros(numPart,dim);
%Init PB
for i=1:numPart
    PB(i) = handleFunc(X(i,:));
    PBSol(i,:) = X(i,:);
end

%Init GB
[GB,GBIndex] = min(PB);
GBSol = X(GBIndex,:);

disp("Valores Iniciales:");
disp("------------------");
disp("X:");
disp(X);
disp("V:");
disp(V);
disp("PB:");
disp(PB);
disp("GB:");
disp(GB);
disp("------------------");


%-------------------------------------------------------------------------
    
    %Funcion de utilidad para calcular la velocidad de una particula
    function vel = velocity(omega, c1,r1,c2,r2, vels, Pb, xi, Gb)
        vel = omega*vels + c1*r1.*(Pb-xi)+c2*r2.*(Gb-xi);
    end

%-------------------------------------------------------------------------

for i=1:maxIter
    
    for j=1:numPart
        
        r1 = rand();
        r2 = rand();
        vel = velocity(omega,c1,r1,c2,r2,V(j,:),PBSol(j),X(j,:),GBSol);
        
        V(j,:) = vel;
        %disp("Interacion "+i + " Parte: " + j);
        X(j,:) = X(j,:) + vel;
        
        %Si se sale de bounds, regresalo.
        for k=1:dim
            if X(j,k) > bounds(1,k)
                X(j,k) = bounds(1,k);            
            elseif X(j,k) < bounds(2,k)
                X(j,k) = bounds(2,k);
            end
        end
        
        newPossiblePersonalBest = handleFunc(X(j,:));
        if newPossiblePersonalBest < PB(j)
            PB(j) = newPossiblePersonalBest;
            PBSol(j,:) = X(j,:);
        end

    end
    
    [minAux,minAuxIndex] = min(PB);
    if minAux < GB
        GB = minAux;
        GBIndex = minAuxIndex;
        GBSol = X(GBIndex,:);
    end
    
    disp("Iteracion " + i + ":") ;
    disp("------------------");
    disp("X:");
    disp(X);
    disp("V:");
    disp(V);
    disp("PB:");
    disp(PB);
    disp("GB:");
    disp(GB);
    disp("------------------");
    
  
end

output = struct(...
        'solution', GBSol,...
        'fitness', GB );
    
end