function [Alg,Setting] = InputAlg(Setting)
% Set the algorithm profile for solving the targeted problem.

if ~isempty(Setting.AlgFile) && ~strcmp(Setting.AlgFile,'None')
    tempAlg = load(Setting.AlgFile);
    Alg = tempAlg.algs(1);
    Setting.AlgP = length(Alg.operator);
else
    Setting.AlgP = 1;
    currOp   = cell(1,Setting.AlgP);
    currPara = cell(1,Setting.AlgP);
    switch Setting.AlgName        
        case 'Continuous Genetic Algorithm'
            currOp{1}.Choose = 'choose_tournament';
            currOp{1}.Search = {'cross_sim_binary','search_mu_polynomial',[-inf,1]};
            currOp{1}.Update = 'update_round_robin';
            currPara{1}.Search = {20,[0.2;20]}; % {crossover distribution;[mutation probability; mutation distribution]}
        case 'Evolutionary Programming'
            currOp{1}.Choose = 'choose_tournament';
            currOp{1}.Search = {'search_mu_gaussian','',[-inf,1]};
            currOp{1}.Update = 'update_round_robin';
        case 'Fast Evolutionary Programming'
            currOp{1}.Choose = 'choose_tournament';
            currOp{1}.Search = {'search_mu_cauchy','',[-inf,1]};
            currOp{1}.Update = 'update_round_robin';
        case 'CMA-ES'
            currOp{1}.Choose = 'choose_traverse';
            currOp{1}.Search = {'search_cma','',[-inf,1]};
            currOp{1}.Update = 'update_greedy';
        case 'Estimation of Distribution'
            currOp{1}.Choose = 'choose_traverse';
            currOp{1}.Search = {'search_eda','',[-inf,1]};
            currOp{1}.Update = 'update_greedy';
        case 'Particle Swarm Optimization'
            currOp{1}.Choose = 'choose_traverse';
            currOp{1}.Search = {'search_pso','',[-inf,1]};
            currOp{1}.Update = 'update_pairwise';
            currPara{1}.Search = {0.1,[]}; % inertia weight 
        case 'Differential Evolution'
            currOp{1}.Choose = 'choose_traverse';
            currOp{1}.Search = {'search_de_current','',[-inf,1]};
            currOp{1}.Update = 'update_pairwise'; 
            currPara{1}.Search = {[0.2,0.2],[]}; % {scaling factor, crossover probability}
        case 'Discrete Genetic Algorithm'
            currOp{1}.Choose = 'choose_tournament';
            currOp{1}.Search = {'cross_point_uniform','search_reset_rand',[-inf,1]};
            currOp{1}.Update = 'update_round_robin';
            currPara{1}.Search = {0.2,0.2}; % {crossover probability, reset probability}
        case 'Discrete Iterative Local Search'
            currOp{1}.Choose = 'choose_traverse';
            currOp{1}.Search = {'search_reset_one','',[0.05,10]; % [fitness improve rate,innerGmax]
                                'reinit_discrete','',[-inf,1]};
            currOp{1}.Update = 'update_greedy';
        case 'Permutation Genetic Algorithm'
            currOp{1}.Choose = 'choose_tournament';
            currOp{1}.Search = {'cross_order_two','search_swap',[-inf,1]};
            currOp{1}.Update = 'update_round_robin';
        case 'Permutation Iterative Local Search'
            currOp{1}.Choose = 'choose_traverse';
            currOp{1}.Search = {'search_insert','',[0.05,10];
                                'reinit_permutation','',[-inf,1]};
            currOp{1}.Update = 'update_greedy';
        case 'Permutation Variable Neighborhood Search'
            currOp{1}.Choose = 'choose_traverse';
            currOp{1}.Search = {'search_swap','',[0.05,10];
                                'search_scramble','',[0.05,10];
                                'search_insert','',[0.05,10]};
            currOp{1}.Update = 'update_greedy';
        case 'ICA'
            currOp{1}.Choose = 'choose_ica';
            currOp{1}.Search = {'search_ica','',[-inf,1]};
            currOp{1}.Update = 'update_greedy';
            currPara{1}.Choose = 10; % inertia weight
            currPara{1}.Search = {[0.6,0.5],[]}; % [p1,alpha]
    end

    for i = 1:Setting.AlgP
        if ~isfield(currOp{i},'Archive')
            currOp{i}.Archive = '';
        end
        if ~isfield(currPara{i},'Choose')
            currPara{i}.Choose = [];
        end
        if ~isfield(currPara{i},'Search')
            currPara{i}.Search = cell(size(currOp{1}.Search,1),2);
        end
        if ~isfield(currPara{i},'Update')
            currPara{i}.Update = [];
        end
    end

    Alg = DESIGN;
    Alg = Alg.Construct(currOp,currPara);
end
end