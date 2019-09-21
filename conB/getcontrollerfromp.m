function addcset=getcontrollerfromp(solucset,potentialcset)
cl=length(solucset);
for i=1:cl
    potentialcset(solucset(i))=0;
end
addcset=find(potentialcset);