function ok = consistencycheck(parm,Xc,M)
global percentage
nmin = percentage*M;             % size should of consensus set should at least has
ok = (length(Xc)>=nmin);         %            a size larger than 50% of the data set                   
end