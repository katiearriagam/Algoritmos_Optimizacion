% La función recibe:
% Fitness = un handle a una función fitness,
% ProblemDim = un entero que indica la cantidad de dimensiones,
% LowerBoundV = un vector del tamaño de las dimensiones que contiene el
% minimo de cada dimensión
% UpperBoundV = un vector del tamaño de las dimensiones que contiene el
% maximo de cada dimensión
% pop_size = un entero que indica el tamaño de la población
% CrossoverRate = un flotante que indica la probabilidad de cruza
% DiffWeight = un flotante que indica el differential weight
% StopCriteria = un entero que indicala cantidad maximas de evaluaciones (maxgens)


% CrossOverMethod: String
	% 'bin': Binomial
	% 'exp': Exponential


% DE/j/m/z
% j: Base vector selection scheme
% m: how many scaled vector differences adding
% z: Crossover method

% BaseVectorSelection: 
	% 'rand'
	% ''
    
% How to run
% DE(handle, 2, [-10, -10], [10, 10], 100, 0.8, 0.9, 1000, 'bin', 'rand')

function valuesO = DE(Fitness, ProblemDim, LowerBoundV, UpperBoundV, pop_size, crossoverRate, DiffWeight, StopCriteria, crossOverMethod, baseVectorSelection)

	% Set random seed
	rng('default');


	% Vector que contiene la mejor solución de cada dimensión
	best_sol = zeros(1, ProblemDim);
	best_fitness = inf;



	% Definir la estructura de salida
	valuesO = struct;
	valuesO(1).Best_sol = best_sol;
	valuesO(1).Best_fitness = best_fitness;
	valuesO(1).Best_Fitness_Iter = [];
	valuesO(1).Mean_Fitness_Iter = [];
	valuesO(1).STD_Fitness_Iter = [];


	% Contadores para calcular la cantidad minima y maxima de veces
	% que no hubo un cambio en el fitness de la población.
	min_evaluations = 0;
	max_evaluations = 0;
	min_value = inf;

	FitPopulation = [];


	% Random Population
	for i = 1:ProblemDim
		Population(:, i) = getRandomValue(LowerBoundV, UpperBoundV, pop_size, 1);
	end
	% Population = rand(pop_size, ProblemDim);
	TrialPop   = zeros(pop_size, ProblemDim);
	
	
	% Calcular el fitness de cada población
	FitPopulation = arrayfun(@(n) Fitness(Population(n,:)), 1:size(Population,1));

	%GlobalBest = zeros(1, ProblemDim);

	generation = 0;
	while generation < StopCriteria % Generation counter
		
		Violation = zeros(pop_size, 1);
		for i = 1:pop_size % for all rows in population

			% Elige tres individuales de manera aleatoria
			grabIndividuals = datasample(Population, 3, 'Replace', false);


			% Mutation
			switch baseVectorSelection
				case 'rand'
					vig = grabIndividuals(1, :) + DiffWeight.*(grabIndividuals(2, :) - grabIndividuals(3, :));
				case 'best'
					error('Not implemented')
				case 'current'
					error('Not implemented')
				case 'rtb'
					error('Not implemented')
				otherwise
					error('Invalid option for vector selection')
			end


			% CROSSOVER:

			% Indice que vamos a cambiar sin importar el crossoverRate
			randomForcedIndex = ceil(rand()*(ProblemDim-1) + 1);

			% Change randomForcedIndex

			% target vector: poblacion original

			flag = false;
			for j = 1:ProblemDim
				% Agregar los valores que se van a quedar
				% En vez del if else solo hago un caso inverso de if para solo agregar los valores que se van a quedar
				if vig(j) < LowerBoundV(j) || vig(j) > UpperBoundV(j)
					Violation(i) = 1;
					break;
				end

				if crossOverMethod == 'bin' % binary
					if rand() > crossoverRate && j ~= randomForcedIndex
						vig(j) = Population(i,j);
					end
				else % exponential
					if ~flag && rand() > crossoverRate
						flag = true;
					end
					if flag
						% select from target
						vig(j) = Population(i, j);
						%else % no-op
						% select from mutant
					end

				end
			end
			% vig is now the trial vector
			TrialPop(i, :) = vig;

		end

		% SELECTION:
		for i = 1:pop_size
			if Violation(i) == 1
				fitnessEval = 10e12;
			else
				fitnessEval = Fitness(TrialPop(i,:));
			end
			if fitnessEval <= FitPopulation(i) % if you're a better fit, replace the target vector in the next generation
				Population(i, :) = TrialPop(i,:);
				FitPopulation(i) =  fitnessEval;
				if fitnessEval < min_value
					min_value = fitnessEval;
					if min_evaluations > max_evaluations
						max_evaluations = min_evaluations;
					end
					min_evaluations = 0;
				end
			end
		end
		% Modifica toda la poblacion y deja a los de Fitness menor
		generation = generation+1;

		min_evaluations = min_evaluations + 1;
		% Almacena el mejor, promedio y la desviación estandar de cada
		% dimensión
		valuesO(1).Best_Fitness_Iter = [valuesO(1).Best_Fitness_Iter ; min(FitPopulation)];
		valuesO(1).Mean_Fitness_Iter = [valuesO(1).Mean_Fitness_Iter ; mean(FitPopulation)];
		valuesO(1).STD_Fitness_Iter = [valuesO(1).STD_Fitness_Iter ; std(FitPopulation)];

	end


	valuesO(1).max_evaluations = max_evaluations;
	[valuesO(1).Best_fitness, Index]  = min(FitPopulation);
	valuesO(1).Best_sol = Population(Index,:);


	% figure(1);
	% plot(valuesO(1).Best_Fitness_Iter, 'o-','linewidth',3,'markersize',40,'markerfacecolor','g');
	% title("Best fitness");
	% xlabel("Iterations");
	% ylabel("Fitness value");
	% figure(2);
	% plot(valuesO(1).Mean_Fitness_Iter, 'o-','linewidth',3,'markersize',40,'markerfacecolor','g');
	% title("Mean fitness");
	% xlabel("Iterations");
	% ylabel("Fitness value");
	% figure(3);
	% plot(valuesO(1).STD_Fitness_Iter, 'o-','linewidth',3,'markersize',40,'markerfacecolor','g');
	% title("STD fitness");
	% xlabel("Iterations");
	% ylabel("Fitness value");
end
