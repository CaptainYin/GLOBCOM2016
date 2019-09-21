function k=generatesetbydelay(delay,node_num,node_mapping,allshorestpath,potentialcset)
%@author:Heqing Yin 2016Äê1ÔÂ26ÈÕ21:00:28
%node_mapping is a vector generate by vne
%node_num is the total node number
%allshorestpath is node_num to node_num cell matrix generate by dijkstra
%return the the node in node_mapping which each node can reached in delay
k=cell(node_num,1);
potentialcsetind=find(potentialcset);
for i=1:node_num
     k{i}.serverset=[];
    if(isempty(find(potentialcsetind==i,1)))
     k{i}.vaild=0;%0 reprsent can not be a controller
     continue;
    end
     k{i}.vaild=1;
    for j=1:length(node_mapping)
        if(allshorestpath(i,node_mapping(j))<delay)
            k{i}.serverset=[k{i}.serverset;node_mapping(j)];
        end
    end
end