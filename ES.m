function output = ES(functionHandle, populationSize, lambda, minBounds, maxBounds, maxIterations, rho, crossoverOption, mutationOption, selectionOption, parameters)
    [rowsMin, colsMin] = size(minBounds);
    [rowsMax, colsMax] = size(maxBounds);
    population = zeroes(populationSize, colsMax);
    for i = 1: rowsMin
        population(:,i) = getRandomValue(minBounds(i), maxBounds(i), populationSize, colsMax);
    end
    populationFitness = arrayfun(@(n) functionHandle(population(n,:)), 1: size(population,1));
    for i = 1: maxIterations
        for j = 1: lambda
            randomPopulation = datasample(population, rho, "Replace", false);
            children = applyCrossover(crossoverOption, params)
            if crossoverOption == 4 % Only one child
                children(1) = applyMutation(mutationOption, children(1));
            else % Two childrens
                children(1) = applyMutation(mutationOption, children(1));
                children(2) = applyMutation(mutationOption, children(2));
            end
%             childrenFitness = arrayfun(@(n) function
        end
    end
end