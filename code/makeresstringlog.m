function [ string ] = makeresstring(p, slope)

% function creates string based on trend test result to summarize findings
% (linear regression, lognormal distribution)

global significancelevel


if significancelevel < p
    string = 'No significant trend';
elseif isnan(p)
    string = '';
else
    string = sprintf('Significant trend at slope = %.2g percent/year',((10^(slope*365.25))-1)*100);
end
end


