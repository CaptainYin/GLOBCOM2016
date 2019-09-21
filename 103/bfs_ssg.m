function [subgraphs,sub_node_num] = bfs_ssg(topo)
node_num = size(topo,1);
flag = zeros(node_num,1);
remain_node_num = node_num;
sub_node_num = [];
subg_num = 1;
v = 1;
flag(v) = 1;
while (~(remain_node_num == 0))
    tmp_nodes = v;
    sq = tmp_nodes;
    while (~isempty(sq))
        tmp = sq(1);
        sq(1) = [];
        neigs = find(topo(:,tmp) ~= 0);
        
        neigs(find(flag(neigs) == 1)) = [];
        
        if(~isempty(neigs))
            tmp_nodes = [tmp_nodes;neigs];
            sq = [sq;neigs];
            flag(neigs) = 1;
            remain_node_num = remain_node_num - length(neigs);
        end
    end
    subgraphs(subg_num).node_num = length(tmp_nodes);
    sub_node_num = [sub_node_num;subgraphs(subg_num).node_num];
    subgraphs(subg_num).original_nodes = tmp_nodes;
    tmp_topo = topo(tmp_nodes,:);
    tmp_topo = tmp_topo(:,tmp_nodes);
    subgraphs(subg_num).topo = tmp_topo;
    subgraphs(subg_num).link_num = length(find(tmp_topo(:) ~= 0))/2;
    
    subg_num = subg_num + 1;
    uv = find(flag == 0);
    if(~isempty(uv))
        v = uv(1);
        flag(v) = 1;
    else
        return;
    end
end
end

