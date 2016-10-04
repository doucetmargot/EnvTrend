
function [S,VarS_x1,VarS_x3,VarS_y1, VarS_y3] = man_k_faster(Sorted,n)

pairs = combnk(1:n,2);

difs_x=Sorted(pairs(:,2),1)-Sorted(pairs(:,1),1);

difs_y=Sorted(pairs(:,2),2)-Sorted(pairs(:,1),2);

Spairs=zeros(size(difs_x));

pairs_flagsa = Sorted(pairs(:,1),3:4);

pairs_flagsb = Sorted(pairs(:,2),3:4);



% a less than b, a is detect and b not max:

Spairs(difs_y>0 & ~pairs_flagsa(:,2) & ~pairs_flagsb(:,1)) = 1;
   
% a greater than b, a is detect and b not max:

Spairs(difs_y<0 & ~pairs_flagsa(:,1) & ~pairs_flagsb(:,2)) = -1;

if sum(Sorted(:,3))>0

    % a equals b, a is non detect and b detect (eg. <5 to 5):

    Spairs(difs_y==0 & pairs_flagsa(:,1) & ~pairs_flagsb(:,1)) = 1;

     % a equals b, b is non detect and a detect (eg. 5 to <5):

    Spairs(difs_y==0 & ~pairs_flagsa(:,1) & pairs_flagsb(:,1)) = -1;

end

if sum(Sorted(:,4))>0

    % a equals b, a is max and b not max (eg. >5 to 5):

    Spairs(difs_y==0 & pairs_flagsa(:,2) & ~pairs_flagsb(:,2)) = -1;

    % a equals b, b is max and a not max (eg. 5 to >5)

    Spairs(difs_y==0 & ~pairs_flagsa(:,2) & pairs_flagsb(:,2)) = 1;
    
end


VarS_y1 = 18*sum(Spairs==0);
VarS_y3 = 2*sum(Spairs==0);

ind_zero = find(difs_x == 0);  %All ties in time domain forced to zero

VarS_x1 = 18*length(ind_zero);
VarS_x3 = 2*length(ind_zero);


Spairs(ind_zero) = 0;


S=sum(Spairs);
end




