function subNet_o =  recoversubnet(solution,subNet,requests)
link_mapping = solution.link_mapping;% get the number of virtual links
node_mapping = solution.node_mapping;% get the node-mapping vector
v_link_num = length(link_mapping);% get the link-mapping vector
slot_allocated_s = solution.allocated_starting_index;% get the allocated slot indices
slot_allocated_e = solution.allocated_ending_index;
cpu = requests.cpu(1);% get the computing resource
% last_slot_index = subNet.initlized_slot_number_on_each_link; % initialized slot number of each links
subNet.cpu(node_mapping) = subNet.cpu(node_mapping) + cpu;% update the computing resources

% GC = subNet.GC;
% update the bandwidth resources
for v_link_id = 1:v_link_num
    s_link = link_mapping{v_link_id};
    for s_link_id = 1:size(s_link,1)
		subNet.s_matrix{s_link(s_link_id,1),s_link(s_link_id,2)}(slot_allocated_s:slot_allocated_e) = 0;
        subNet.s_matrix{s_link(s_link_id,2),s_link(s_link_id,1)} = subNet.s_matrix{s_link(s_link_id,1),s_link(s_link_id,2)};
    end
end
subNet_o = subNet;
end