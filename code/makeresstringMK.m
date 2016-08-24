function [ string ] = makeresstringMK(p, S)

% function creates string based on trend test result to summarize findings
% (Mann-Kendall)
global significancelevel

if significancelevel < p
    string = 'No significant trend';
elseif isnan(p)
    string = 'Insufficient data points.';
else
    if S >0; 
    string = sprintf('Significant positive trend.');
    else
    string = sprintf('Significant negative trend.');
    end
end
end

