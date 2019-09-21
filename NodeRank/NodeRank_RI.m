function RI = NodeRank_RI(Net,flags)
alpha=Net.alpha;
cpu = Net.cpu/Net.initlized_computingcapacity_on_each_link;
degree=Net.degree;
allshorest=Net.allshorestnormalized;
node_num=Net.node_num;
RI=zeros(node_num,1);
mappednode=find(flags);
mappednum=length(mappednode);
%take mappednum==0 into consideration
for i=1:node_num
    if(flags(i)==1)
        RI(i)=-inf;
        continue;
    end
    avgdist=0;
    if mappednum==0
        RI(i)=cpu(i)*degree(i);
        continue;
    end
    for j=1:mappednum
        avgdist=avgdist+allshorest(mappednode(j),i);
    end
RI(i)=cpu(i)*degree(i)+alpha*avgdist/mappednum;
end
end