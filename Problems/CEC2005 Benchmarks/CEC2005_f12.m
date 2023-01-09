function [output1,output2,output3] = CEC2005_f12(varargin)
% The Schwefel's Problem 2.13 from the benchmark for the CEC 2005 Special
% Session on Real-Parameter Optimization.

switch varargin{end}
    case 'construct'
        type     = {'continuous','static','certain'};
        Problem  = varargin{1};
        instance = varargin{2};
        orgData  = load('schwefel_213_data');
        a        = orgData.a;
        b        = orgData.b;
        alpha    = orgData.alpha;
        Data     = struct('a',[],'b',[],'A',[]);
        for i = 1:length(instance)
            Problem(i).type = type;
            
            if instance(i) == 1
                D = 10;
            elseif instance(i) == 2
                D = 30;
            elseif instance(i) == 3
                D = 50;
            else
                error('Only instances 1, 2, and 3 are available.')
            end
            lower = zeros(1,D)-100;
            upper = zeros(1,D)+100;
            Problem(i).bound = [lower;upper];
            
            if length(alpha) >= D
                curr_alpha = alpha(1:D);
                curr_a = a(1:D,1:D);
                curr_b = b(1:D,1:D);
            else
                curr_alpha = -3+6*rand(1,D);
                curr_a = round(-100+200.*rand(D,D));
                curr_b = round(-100+200.*rand(D,D));
            end
            curr_alpha = repmat(curr_alpha,D,1);
            curr_A = sum(curr_a.*sin(curr_alpha)+curr_b.*cos(curr_alpha),2);
            Data(i).a = curr_a;
            Data(i).b = curr_b;
            Data(i).A = curr_A;
        end
        output1 = Problem;
        output2 = Data;
        
    case 'evaluate'
        Data = varargin{1};
        a    = Data.a;
        b    = Data.b;
        A    = Data.A;
        Decs = varargin{2};
        
        [N,D] = size(Decs);
        fit = zeros(N,1);
        for i = 1:N
            xx = repmat(Decs(i,:),D,1);
            B  = sum(a.*sin(xx)+b.*cos(xx),2);
            fit(i) = sum((A-B).^2,1);
        end
        output1 = fit-460;
end

if ~exist('output2','var')
    output2 = [];
end
if ~exist('output3','var')
    output3 = [];
end
end