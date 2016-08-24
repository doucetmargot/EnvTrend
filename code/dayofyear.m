function [ output ] = dayofyear( input )
% Outputs day of year from full date in number format

dvector = datevec(input);

output = daysdif(datenum(1990,01,01),datenum(1990,dvector(:,2),dvector(:,3)));

end

