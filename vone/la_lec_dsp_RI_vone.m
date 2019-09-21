function [solution,subNet_o] = la_lec_dsp_RI_vone(VONR,subNet)
%% Layered Local Information based Transparent Virtual Optical Network Embeding
subNet_o = subNet;% save the original substrate 
v_node_num = VONR.node_num;% get the number of virtual nodes
v_link_num = VONR.link_num;% get the number of virtual links

node_req = VONR.cpu(1);% switching capacity requirement
link_req = VONR.bandwidth(1);% slot number requirement
v_topology = VONR.matrix;% get the VON topology

s_node_num = subNet.node_num;% get the number of substrate nodes
s_link_num = subNet.link_num;% get the number of substrate links
o_node_capacity = subNet.cpu;% get the capacity of each substrate node
s_matrix = subNet.s_matrix;% get the link usage information matrix
s_topology = subNet.topology;% get the substrate topology
S = subNet.initlized_slot_number_on_each_link;% get the last index of slots

v_degree = degree(v_topology);% get the degree of each virtual node
[v_degree_sort,order_v_degree] = sort(v_degree,'descend');% sort the degree of each node

node_mapping_flag = 1;% flag bit for node mapping:0 --- failure, 1 ---- success
link_mapping_flag = 1;% flag bit for link mapping: ...



no_more_try = 0;% flag bit to stop the main process
% main processtarts
for layer = 1:(S - link_req + 1)
    
% constructing layered graph
layered_topo = s_topology;
% cut the links that do not have enough slots on that layer
for n1 = 1:s_node_num
    for n2 = (n1+1):s_node_num
        if(s_topology(n1,n2) ~= 0)
            bit_mask_temp = s_matrix{n1,n2}(layer:(layer + link_req - 1));
            if(sum(bit_mask_temp) ~= 0)
                layered_topo(n1,n2) = 0;
                layered_topo(n2,n1) = 0;
            end
        end
    end
end

[subgraphs,sub_node_num] = bfs_ssg(layered_topo);% find all indepedent subgraphs

% precheck
listing = find(sub_node_num >= v_node_num);
if(isempty(listing))
    solution.state = -1;
    continue;
end

[~,order_nn] = sort(sub_node_num(listing),'descend');% sort the subgraphs

% do node mapping from the subgraph with maximum size to the one with minimum size
for sub_id_id = 1:length(order_nn)
    sub_id = listing(order_nn(sub_id_id));
     node_capacity= o_node_capacity;
    %% node mapping
    node_mapping = zeros(v_node_num,1);% initialize the node mapping vector
    
    layered_sub_topo = subgraphs(sub_id).topo;% get the sub-topology
    original_nodes = subgraphs(sub_id).original_nodes;% get the map from the node id to the node id in the original topology (substrate network topology)
    remaining_node_num = subgraphs(sub_id).node_num;% get the number of nodes in the sub-topology
    remaining_link_num = subgraphs(sub_id).link_num;% get the number of links in the sub-topology
    
    % node degree of all substrate nodes
    s_degree = degree(layered_sub_topo);% get the degrees of each node in the sub-topology
    s_degree_sort = sort(s_degree,'descend');% sort the degrees
    
    % precheck for degree
    if(~isempty(find((s_degree_sort(1:v_node_num) - v_degree_sort) < 0, 1)))
        solution.state = 0;
        continue;
    end
    
    % node rank for the layered subgraph
    flag = zeros(remaining_node_num,1);
    r_s = NodeRank_RI_layered(subNet,flag,node_capacity(original_nodes),layered_sub_topo,original_nodes);% get the local information on each node
    [~,order_r_s] = sort(r_s,'descend');% sort the local information
    
    for v_n = 1:v_node_num
        v_node = order_v_degree(v_n);
        for s_n = 1:remaining_node_num
            s_node = order_r_s(s_n);
            if(flag(s_node) == 0 && node_capacity(original_nodes(s_node)) >= node_req && s_degree(s_node) >= v_degree(v_node))
                node_mapping(v_node) = s_node;
                flag(s_node) = 1;%%%%%%%%%%
                %********************************************
                node_capacity(original_nodes(s_node))  =node_capacity(original_nodes(s_node)) - node_req;
                 r_s = NodeRank_RI_layered(subNet,flag,node_capacity(original_nodes),layered_sub_topo,original_nodes);
                [~,order_r_s] = sort(r_s,'descend');
  
                %*********************************************
                break;
            end
        end
        if(s_n == remaining_node_num && node_mapping(v_node) == 0)
            node_mapping_flag = 0;
            break;
        end
    end
    
    if(node_mapping_flag == 0)
        node_mapping_flag = 1;
        solution.state = 0;
         if(remaining_node_num == s_node_num && remaining_link_num == s_link_num)
            no_more_try = 1;
            break;
        else
             continue;
        end
    end
    
    %% link mapping
    link_mapping = cell(v_link_num,1);
    dist_vector = zeros(v_link_num,1);% the distances of the paths the virtual links mapped onto
    hop_vector = zeros(v_link_num,1);% the hops of the paths 
    source = node_mapping(VONR.start_node);
    sink = node_mapping(VONR.ending_node);
    layered_sub_topo(layered_sub_topo == 0) = Inf;
    for v_l = 1:v_link_num
        s = source(v_l);
        d = sink(v_l);
        [path,hop] = dijkstra(layered_sub_topo,s,d);
        
        if(isempty(path))
            link_mapping_flag = 0;
            break;
        end
        
        if(size(path,2) ~= 1)
            path = path';
        end
        
        link_mapping{v_l} = [original_nodes(path(1:(end-1))),original_nodes(path(2:end))];
        % cut the links used
        for h = 1:hop
            layered_sub_topo(path(h),path(h+1)) = Inf;
            layered_sub_topo(path(h+1),path(h)) = Inf;
			dist_vector(v_l) = subNet.dist_matrix(original_nodes(path(h)),original_nodes(path(h+1))) + dist_vector(v_l);
        end
		hop_vector(v_l) = hop;
    end
    
    if(link_mapping_flag == 0)
        link_mapping_flag = 1;
        solution.state = -1;
        if(remaining_node_num == s_node_num && remaining_link_num == s_link_num)
            no_more_try = 1;
            %%%%
           % fprintf('no more try occurs\n');
            break;
        else
             continue;
        end
    end
    
    node_mapping = original_nodes(node_mapping);
    starting_allocated_index = layer;
    solution.state = 1;
    break;
end
   if(solution.state == 1 || no_more_try == 1)
        break;
   end 
end
% check if mapping failed
if(solution.state ~= 1)
    return;
end

%% update resources
%node_capacity(node_mapping) = 	node_capacity(node_mapping) - node_req;% update node capacity
ending_allocated_index = starting_allocated_index + link_req - 1;
% update link capacity
for v_l = 1:v_link_num
    s_link = link_mapping{v_l};
    for link_id = 1:size(s_link,1)
        s_matrix{s_link(link_id,1),s_link(link_id,2)}(starting_allocated_index:ending_allocated_index) = 1;
        s_matrix{s_link(link_id,2),s_link(link_id,1)} = s_matrix{s_link(link_id,1),s_link(link_id,2)};
    end
end

%% return mapping results
solution.node_mapping = node_mapping;
solution.link_mapping = link_mapping;
solution.allocated_starting_index = starting_allocated_index;
solution.allocated_ending_index = ending_allocated_index;
solution.hop_vector = hop_vector;
solution.dist_vector = dist_vector;

subNet.cpu = node_capacity;
subNet.s_matrix = s_matrix;

subNet_o = subNet;
end







