function subNet_o =  remove_requests(request,subNet)
v_link_num = request.link_num;% get the number of virtual links
node_mapping = request.node_mapping;% get the node-mapping vector
link_mapping = request.link_mapping;% get the link-mapping vector
slot_allocated_s = request.allocated_starting;% get the allocated slot indices
slot_allocated_e = request.allocated_ending;
cpu = request.cpu;% get the computing resource
% last_slot_index = subNet.initlized_slot_number_on_each_link; % initialized slot number of each links
subNet.cpu(node_mapping) = subNet.cpu(node_mapping) + cpu;% update the computing resources
% GC = subNet.GC;
% update the bandwidth resources
for v_link_id = 1:v_link_num
    s_link = link_mapping{v_link_id};
    for s_link_id = 1:size(s_link,1)
		subNet.s_matrix{s_link(s_link_id,1),s_link(s_link_id,2)}(slot_allocated_s:slot_allocated_e) = 0;
        subNet.s_matrix{s_link(s_link_id,2),s_link(s_link_id,1)} = subNet.s_matrix{s_link(s_link_id,1),s_link(s_link_id,2)};
        subNet.bandwidth(s_link(s_link_id,1),s_link(s_link_id,2)) = subNet.bandwidth(s_link(s_link_id,1),s_link(s_link_id,2)) + (slot_allocated_e - slot_allocated_s + 1);
        subNet.bandwidth(s_link(s_link_id,2),s_link(s_link_id,1)) = subNet.bandwidth(s_link(s_link_id,1),s_link(s_link_id,2));
    end
end
subNet_o = subNet;
end