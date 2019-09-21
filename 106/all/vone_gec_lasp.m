function [solution,subNet_o] = vone_gec_lasp(requests,subNet)
%% virtual optical network allocation with basic local resource based node mapping and simple sortest-path based link mapping
subNet_o = subNet; % save the original state of the substrate
GC = subNet.GC;% guard-band slot
last_slot_index = subNet.initlized_slot_number_on_each_link; % initialized slot number of each links
v_node_num = requests.node_num;% get the number of virtual nodes
v_link_num = requests.link_num;% get the number of virtual links
slot = requests.bandwidth(1) + GC;% get the slots the needed by each virtual link taking the guard-bands into consideration
cpu_requirement = requests.cpu(1);% get the computing resource that needed by each virtual node
s_node_num = subNet.node_num;% get the node number of the substrate
s_link_num = subNet.link_num;
s_matrix = subNet.s_matrix;% get the slot-usage matrix
s_topology = subNet.topology;% get the substrate s_topology
cpu_capacity = subNet.cpu;% get the computing resource of each substrate node
s_bandwidth = subNet.bandwidth;

node_mapping = zeros(v_node_num,1);% initialize the node-mapping vector
link_mapping = cell(v_link_num,1);% initialize the link-mapping vector
% Do node mapping
NR_s = NodeRank_GEC(subNet);

v_degree = degree(requests.matrix);
s_degree = degree(s_topology);
[v_v,o_v] = sort(v_degree,'descend');
[v_s,o_s] = sort(NR_s,'descend');
flag = zeros(s_node_num,1);
for v_n = 1:v_node_num
    v_node = o_v(v_n);
    for s_n = 1:s_node_num
        s_node = o_s(s_n);
        if(flag(s_node) == 0 && cpu_capacity(s_node) >= cpu_requirement && s_degree(s_node) >= v_degree(v_node))
            node_mapping(v_node) = s_node;
            flag(s_node) = 1;
            break;
        end
    end
    if(node_mapping(v_node) == 0)
        solution.state = 0;
        return;
    end
end
% Update computing resources
cpu_capacity(node_mapping) = cpu_capacity(node_mapping) - cpu_requirement;





% Do link mapping
source = node_mapping(requests.start_node);
sink = node_mapping(requests.ending_node);

for layer = 1:(last_slot_index - slot + 1)
    % constructing layered graph
    layered_topo = s_topology;
	remaining_link_num = s_link_num;
    % cut the links that do not have enough slots on that layer
    for n1 = 1:s_node_num
        for n2 = (n1+1):s_node_num
            if(s_topology(n1,n2) ~= 0)
                bit_mask_temp = s_matrix{n1,n2}(layer:(layer + slot - 1));
                if(sum(bit_mask_temp) ~= 0)
                    layered_topo(n1,n2) = 0;
                    layered_topo(n2,n1) = 0;
					remaining_link_num = remaining_link_num - 1;
                end
            end
        end
    end
    
    layered_topo(find(layered_topo == 0)) = Inf;
    
    paths = cell(v_link_num,1);
    hops = zeros(v_link_num,1);
    
    link_mapping_flag = 1;
    for v_link_id = 1:v_link_num
        [path,hop] = dijkstra(layered_topo,source(v_link_id),sink(v_link_id));
        if(isempty(path))
            link_mapping_flag = 0;
            if(remaining_link_num == s_link_num)
                solution.state = -1;
                return;
            end
            break;
        end
        
        paths{v_link_id} = path;
        hops(v_link_id) = hop;
        for hop_id = 1:hop
            layered_topo(path(hop_id),path(hop_id+1)) =  Inf;
            layered_topo(path(hop_id+1),path(hop_id)) = Inf;
        end
    end
    if(link_mapping_flag == 1)
        break;
    end
end

if (link_mapping_flag == 0)
    solution.state = -1;
    return;
end

startindex = layer;
endindex = startindex + slot - 1;
hop_vector = zeros(v_link_num,1);
dist_vector = zeros(v_link_num,1);
% get the slot-usage vectors of the used links
for v_link_id = 1:v_link_num
    path = paths{v_link_id};
    hop = hops(v_link_id);
    for hop_id = 1:hop
        s_matrix{path(hop_id),path(hop_id+1)}(startindex:endindex) = 1;
        s_matrix{path(hop_id+1),path(hop_id)}(startindex:endindex) = 1;
        s_bandwidth(path(hop_id),path(hop_id+1)) = s_bandwidth(path(hop_id),path(hop_id+1)) - slot;
        s_bandwidth(path(hop_id+1),path(hop_id)) = s_bandwidth(path(hop_id),path(hop_id+1));
		dist_vector(v_link_id) = dist_vector(v_link_id) + subNet.dist_matrix(path(hop_id),path(hop_id+1));    
    end
    	hop_vector(v_link_id) = hop;
    if(size(path,2) ~=1)
        tmp_path = path';
    else
        tmp_path = path;
    end
    link_mapping{v_link_id} = [tmp_path(1:(end-1)),tmp_path(2:end)];
end



% Write back all informations
subNet.cpu = cpu_capacity;
subNet.s_matrix = s_matrix;% the matrix records the slot-uage information
subNet.bandwidth = s_bandwidth;

subNet_o = subNet;
solution.state = 1;
solution.node_mapping = node_mapping;
solution.link_mapping = link_mapping;
solution.allocated_starting_index = startindex;
solution.allocated_ending_index = endindex;
solution.dist_vector = dist_vector;
solution.hop_vector = hop_vector;
end