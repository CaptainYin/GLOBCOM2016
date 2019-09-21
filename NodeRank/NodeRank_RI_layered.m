function LEC = NodeRank_RI_layered(Net,flags,node_capacity,topology,original_nodes)
degree_layer = degree(topology);
mind=min(degree_layer);
maxd=max(degree_layer);
if(mind==maxd)
    degree_layer=degree_layer/mind;
else
    degree_layer=(degree_layer-mind)/(maxd-mind);
end
node_capacity=node_capacity/Net.initlized_computingcapacity_on_each_link;
LEC = node_capacity .* degree_layer;
alpha=Net.alpha;
beta=Net.beta;
allshorest=Net.allshorestnormalized;
node_num=length(node_capacity);
mappednode=find(flags);
mappednum=length(mappednode);
  if mappednum==0
        return;
  end
%take mappednum==0 into consideration
for i=1:node_num%the node_num of this subgraph
    if(flags(i)==1)
        LEC(i)=-inf;
        continue;
    end
    avgdist=0;
    for j=1:mappednum
        avgdist=avgdist+allshorest(original_nodes(mappednode(j)),original_nodes(i));
    end
LEC(i)=LEC(i)*beta+alpha*avgdist/mappednum;
end
end