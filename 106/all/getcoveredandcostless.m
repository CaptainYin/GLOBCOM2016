function [subsolu,state]=getcoveredandcostless(cset,clackset,cslset,lack_num)
l=length(cslset);%lack_num length 14 index by clackset
p=powerset(l);
pl=length(p);
k=zeros(pl,1);
 b=zeros(14,1);
for i=1:pl
    a=b;
    cind=find(p(i,:));% the index of cset
    for j=1:length(cind)%cind(j) the index of cset
        sset= cslset{cind(j)}.serverset;%index of all node 
        ssetl=length(sset);
        if(ssetl==0)
            continue;
        end
        for ii=1:ssetl
            a(sset(ii))=1+a(sset(ii));
        end
    end%a the NO.i combination can server node in clackset
    if(coverlackset(a,clackset,lack_num))
        k(i)=1;%NO.i combination can cover clackset lack_num
    end
end
    covercombind=find(k);%the index vector of combnation which can cover
   cl=length(covercombind);
   if(cl==0)
       state=0;
       subsolu=[];
       return;
   end
controllersetarray=cell(cl,1);
cost=zeros(cl,1);
for i=1:cl
       csetind=find(p(covercombind(i),:));%index of cset
       controllerind=cset(csetind);%index of all node
      c_num=length(controllerind);
      for j=1:c_num
          cost(i)=cost(i)+cslset{csetind(j)}.avgcost;
      end
    controllersetarray{i}.c_num=c_num;
    controllersetarray{i}.controllerset=controllerind';
end
[~,oindex]=sort(cost);
state=1;
subsolu=controllersetarray{oindex(1)};
subsolu.cost=cost(oindex(1));

