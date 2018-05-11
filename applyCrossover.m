function result = applyCrossover(method, parents, params)
    parent1 = parents(1);
    parent2 = parents(2);
    
    switch method
        case 1
            % One point crossover
            stopPos = params(1).stopPos;
            child1 = [];
            child2 = [];
            child1 = [child1 parent1(1:stopPos)];
            child1 = [child1 parent2(stopPos+1:end)];
            child2 = [child2 parent2(1:stopPos)];
            child2 = [child2 parent1(stopPos+1: end)];
            result = [child1; child2];
        case 2
            % Uniform crossover
            mask = floor(getRandomValue(0, 1, 1, 8));
            child1 = [];
            child2 = [];
            for i = 1: size(mask)
                if mask(i) == 1
                    child1 = [child1 parent1(i)];
                    child2 = [child2 parent2(1)];
                else
                    child1 = [child1 parent2(i)];
                    child2 = [child2 child2(1)];
                end
            end
            result = [child1 ; child2];
        case 3
            % Arithmetic crossover
            alpha = params(1).alpha;
            child = alpha.*parent1 + (1 - alpha).*parent2;
            result = [child];
        case 4
            % Blend crossover
            result = [BLX(parent1, parent2)];
        otherwise
            disp("no");
    end
end