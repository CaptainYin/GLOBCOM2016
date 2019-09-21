function c=allinpotentialcset(potentialcset,cind)
potentialcsetind=find(potentialcset);
cindl=length(cind);
for i=1:cindl
    if(~find(potentialcsetind==cind(i),1))
        c=0;
        return;
    end
end
c=1;

    