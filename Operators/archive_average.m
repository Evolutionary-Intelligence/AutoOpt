function [output1,output2] = archive_average(varargin)
% Collect the average and standard deviation of solution's fitness of each
% iteration.

mode = varargin{end};
switch mode
    case 'execute'
        Solution = varargin{1};
        ArchAve  = varargin{2};

        Fitness  = Solution.fits;
        output1  = [mean(Fitness),std(Fitness)];
        output1  = [ArchAve;output1];
    
    case 'parameter'
        % no parameter

    case 'behavior'
        output1 = {'';''}; 
end

if ~exist('output1','var')
    output1 = [];
end
if ~exist('output2','var')
    output2 = [];
end
end