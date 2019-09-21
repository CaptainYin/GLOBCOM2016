function cslset=getserversetbydelay(delay,cset,clackset,allshorestpath,B)
clacksetl=length(clackset);
csetl=length(cset);
cslset=cell(csetl,1);
for i=1:csetl
    cslset{i}.avgcost=0;
    cslset{i}.serverset=zeros(clacksetl,1);
end
for i=1:clacksetl
    ind=clackset(i);
    for j=1:csetl
        if(allshorestpath(ind,cset(j))>delay)
            continue;
        end
        cslset{j}.avgcost=cslset{j}.avgcost+allshorestpath(ind,cset(j));
        cslset{j}.serverset(ind)=1;
    end
end
for i=1:csetl
     cslset{i}.serverset=find(cslset{i}.serverset);
     if(isempty(cslset{i}.serverset))
         cslset{i}.avgcost=B;
         continue;
     end
    cslset{i}.avgcost=cslset{i}.avgcost/length(cslset{i}.serverset)+B;
end
    
    
    