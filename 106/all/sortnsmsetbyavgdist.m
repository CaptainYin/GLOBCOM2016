function sortednsmset=sortnsmsetbyavgdist(nsmset,allshorestdistandpath,B)
%sortednsmset:length:node_num
%field:oindex,avgcost,serverset
node_num=length(nsmset);
k=cell(node_num,1);
for i=1:node_num
     nsmset{i}.avgcost=0;
    sset=nsmset{i}.serverset;
      ssetl=length(sset);
    if(ssetl==0)
        nsmset{i}.avgcost=B;
        continue;
    end
    for j=1:ssetl
        nsmset{i}.avgcost=nsmset{i}.avgcost+allshorestdistandpath(sset(j),i);
    end
  nsmset{i}.avgcost=nsmset{i}.avgcost/ssetl+B;
end
avgcost=zeros(node_num,1);
for i=1:node_num
    avgcost(i)= nsmset{i}.avgcost;
end
[~,oindex]=sort(avgcost);
for i=1:node_num
   k{i}=nsmset{oindex(i)};
   k{i}.oindex=oindex(i);
end
sortednsmset=k;