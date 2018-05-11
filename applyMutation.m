function child = applyMutation(mutation, child)
switch mutation
    case 1
        % Bit-flip mutation
        randomIndex = getRandomValue(0, max(child), 1, size(child));
        child(randomIndex) = bitxor(child(randomIndex), 1);
    case 2
        % Uniform mutation
        randomIndex = getRandomValue(0, max(child), 1, size(child));
        child(randomIndex) = (max(child) - min(child))*rand() + min(child);
    case 3
        % Boundary mutation
        randomIndex = getRandomValue(0, max(child), 1, size(child));
        s = ceil(rand());
        child(randomIndex) = (1 - s)*min(child) + s*max(randomIndex);
    case 4
        % Normal mutation
        randomIndex = getRandomValue(0, max(child), 1, size(child));
        child(randomIndex) = child(randomIndex) + std(child)*normrnd(0,1);
    otherwise
        disp("no");
end