function [new_solu,acc,new_s]=addcontroller(MAIN_DELAY,ind,index,sortednsmset,solu,allshorestdistandpath,lack_num,s,nml,node_mapping)
%ind the unrelable node index of all node
%index the unrelable node index of node_mapping
%acc={1,0}0:failed
node_num=14;
cset=solu.controllerset;
c=zeros(node_num,1);
for i=1:solu.c_num
    c(cset(i))=1;
end
c=~c;
for i=1:node_num
    if(c(i)==0)
        continue;
    end
    if(allshorestdistandpath(i,ind)>MAIN_DELAY)%add cpu check 2016年1月28日11:19:57  delete cpu check 2016年1月29日22:09:43
        c(i)=0;
    end
end
%the remain 1 represent the node can server ind in main_delay and not in
%cset
%TODO:sort them by avgcost in sortednsmset and if num is enough,update
%solu,s
%and set acc=1,or set acc=0 and return
bumc=find(c);
bumc_num=length(bumc);
if(bumc_num<lack_num)
    acc=0;
    new_solu=solu;
    new_s=s;
    return;
end
bumccost=zeros(bumc_num,1);
for i=1:bumc_num
    for j=1:node_num
        if(bumc(i)==sortednsmset{j}.oindex)
            bumccost(i)=sortednsmset{j}.avgcost;
            break;
        end
    end
end
[sortedcost,oind]=sort(bumccost);
additionc=zeros(lack_num,1);
for i=1:lack_num
   additionc(i)=bumc(oind(i));
end
s{index}.mc_num=s{index}.mc_num+lack_num;
s{index}.mc_indexset=[s{index}.mc_indexset;additionc];

new_solu.controllerset=[solu.controllerset;additionc];
new_solu.c_num=solu.c_num+lack_num;
new_solu.cost=solu.cost+sum(sortedcost(1:lack_num));
acc=1;
if(index<nml)
    for i=index+1:nml
        for j=1:lack_num
            if(allshorestdistandpath(node_mapping(i),additionc(j))<MAIN_DELAY)
                s{i}.mc_indexset=[s{i}.mc_indexset;additionc(j)];
                s{i}.mc_num=s{i}.mc_num+1;
            end
        end
    end
end
new_s=s;


    
    




