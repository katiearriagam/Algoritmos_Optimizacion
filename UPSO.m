%function output = UPSO(handleFunc,bounds,maxIter,c1,c2,omega,numPart,numVec,vecW)
%   
%   ejemplo de llamada:
%
%   UPSO(handle,[[10,10];[-10,-10]], 100, 2, 2, .7, 10,5,0.5)
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

function output = UPSO(handleFunc,bounds,maxIter,c1,c2,omega,numPart,numVec,vecW)

%cantidad de dimensiones por particula
dim = size(bounds,2);

%Init Posiciones
for j = 1:numVec
    for i=1:dim
        X(j,:,i) = ((bounds(1,i) - bounds(2,i)) * rand(numPart,1)) + bounds(2,i); 
    end
end

%Init Velocidades
V = zeros(numVec,numPart,dim);

%Init PB
for j = 1:numVec
    for i=1:numPart
        PB(j,i) = handleFunc(X(j,i,:));
        PBSol(j,i,:) = X(j,i,:);
    end
end

%Init GB
for j = 1:numVec
    [GBaux,GBIndexaux] = min(PB(j,:));
    GBn(j) = GBaux;
    GBIndexn(j) = GBIndexaux;
    GBSoln(j,:) = PBSol(j,GBIndexaux,:);
end

[GB,GBIndex] = min(GBn);
GBSol = GBSoln(GBIndex,:);

disp("Valores Iniciales:");
for i = 1:numVec
    disp("Vecindad #" + i);
    pbsol = reshape(PB(i,:),numPart,1);
    xiter = reshape(X(i,:,:),numPart,dim);
    velo = reshape(V(i,:,:),numPart,dim);
    gbsol = GBSoln(i,:);
    gb = GBn(i);
    disp("------------------");
    disp("X:");
    disp(xiter);
    disp("V:");
    disp(velo);
    disp("PB:");
    disp(pbsol);
    disp("GB:");
    disp(gb);
    disp("GBSol:");
    disp(gbsol);
    disp("------------------");
end
%-------------------------------------------------------------------------
    
    %Funcion de utilidad para calcular la velocidad de una particula
    function vel = velocity(omega, c1,r1,c2,r2,r3,r4, vels, Pb, xi, Gb,Gbn,uval)
        L = omega*vels + c1*r1.*(Pb-xi)+c2*r2.*(Gbn-xi);
        R = omega*vels + c1*r3.*(Pb-xi)+c2*r4.*(Gb-xi);
        vel = L*(1-uval) + R*uval;
    end

%-------------------------------------------------------------------------

for i=1:maxIter
    for w = 1:numVec
        for j=1:numPart

            r1 = rand();
            r2 = rand();
            r3 = rand();
            r4 = rand();
            pbsol = reshape(PBSol(w,j,:),1,[]);
            xiter = reshape(X(w,j,:),1,[]);
            velo = reshape(V(w,j,:),1,[]);
            vel = velocity(omega,c1,r1,c2,r2,r3,r4,velo,pbsol,xiter,GBSol,GBSoln(w,:),vecW);
%             disp("velocidad");
%             disp(velo);
%             disp("Pos");
%             disp(xiter);
%             disp("PErsonal best");
%             disp(pbsol);
%             disp("Global");
%             disp(GBSol);
%             disp("Global hood");
%             disp(GBSoln(w,:));
%             disp("Vel calculado");
%             disp(vel);
            V(w,j,:) = vel;
            
            X(w,j,:) = xiter + vel;

            %Si se sale de bounds, regresalo.
            for k=1:dim
                if X(w,j,k) > bounds(1,k)
                    X(w,j,k) = bounds(1,k);            
                elseif X(w,j,k) < bounds(2,k)
                    X(w,j,k) = bounds(2,k);
                end
            end

            newPossiblePersonalBest = handleFunc(X(w,j,:));

            if newPossiblePersonalBest < PB(w,j)
                PB(w,j) = newPossiblePersonalBest;
                PBsol(w,j,:) = X(w,j,:);
            end

        end
        
    end
    for w=1:numVec
        [minAux,minAuxIndex] = min(PB(w,:));
        if minAux < GBn(w)
            GBn(w) = minAux;
            GBIndexn(w) = minAuxIndex;
            GBSoln(w,:) = PBsol(w,minAuxIndex,:);
        end
    end    
    [GB,GBIndex] = min(GBn);
    GBSol = GBSoln(GBIndex,:);
    
    disp("Iteracion #" + i);
    for z = 1:numVec
        disp("Vecindad #" + z);
        pbsol = reshape(PB(z,:),numPart,1);
        xiter = reshape(X(z,:,:),numPart,dim);
        velo = reshape(V(z,:,:),numPart,dim);
        gbsol = GBSoln(z,:);
        gb = GBn(z);
        disp("------------------");
        disp("X:");
        disp(xiter);
        disp("V:");
        disp(velo);
        disp("PB:");
        disp(pbsol);
        disp("GB:");
        disp(gb);
        disp("GBSol:");
        disp(gbsol);
        disp("------------------");
    end
  
end

% topkek=[];
% for i= 1:dim
%     topkek = [topkek X(GBIndex,IndexChido,i)];
% end

output = struct(...
        'solution', GBSol ,...
        'fitness', GB );
    
end