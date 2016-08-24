function [ string ] = makeresstring(p, slope)
% function creates string based on trend test result to summarize findings
% (linear regression)


global significancelevel


if significancelevel < p
    string = 'No significant trend';
elseif isnan(p)
    string = '';
else
    string = sprintf('Significant trend at slope = %.2g /year',slope*365.25);
end
end


