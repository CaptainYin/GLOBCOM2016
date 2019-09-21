function nset=getpotentialcontrollerset(link_mapping,subnet)
link_mappinglength=length(link_mapping);
nset=zeros(14,1);
for i=1:link_mappinglength
    path=link_mapping{i};
    [m,n]=size(path);
    for j=1:n;
        for ii=1:m
            nset(path(ii,j))=1;
        end
    end
end
climit=subnet.climit;
cnum=subnet.cnum;
for i=1:14
    if(cnum(i)>=climit)
        nset(i)=0;
    end
end