function [output1,output2] = search_mu_uniform(varargin)
% The uniform mutation.

mode = varargin{end};
switch mode
    case 'execute'
        Parent  = varargin{1};
        Problem = varargin{2};
        Para    = varargin{3};

        if ~isnumeric(Parent)
            Offspring = Parent.decs;
        else
            Offspring = Parent;
        end
        Prob  = Para;
        [N,D] = size(Offspring);
        
        Lower = Problem.bound(1,:);
        Upper = Problem.bound(2,:);
        ind = rand(N,D) < Prob;
        Temp = unifrnd(repmat(Lower,N,1),repmat(Upper,N,1));
        Offspring(ind) = Temp(ind);
        output1 = Offspring;
        output2 = varargin{5};

    case 'parameter'
        output1 = [0,0.3]; % mutation probability 
    case 'behavior'
        output1 = {'LS','small';'GS','large'}; % small probabilities perform local search
end

if ~exist('output1','var')
    output1 = [];
end
if ~exist('output2','var')
    output2 = [];
end
end
