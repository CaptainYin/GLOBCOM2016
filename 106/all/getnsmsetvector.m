function nsmsetv=getnsmsetvector(nsmset)
nsmsetv=zeros(14,14);
for i=1:14
    sset=nsmset{i}.serverset;
    ssetl=length(sset);
     if(ssetl==0||nsmset{i}.vaild==0)
           continue;
     end
    for j=1:ssetl
    nsmsetv(i,sset(j))=1;
    end
end