function value = getRandomValue(lowerBound, upperBound, rows, columns)
    value = ((upperBound - lowerBound + 1) * rand(rows,columns)) + lowerBound;
end