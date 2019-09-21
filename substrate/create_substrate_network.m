function subNet = create_substrate_network(topo_str,init_sc,init_sn)
switch(topo_str)
    case 'six-node',
        topology = six_node;
    case 'NSF',
        topology = NSF;
    case 'DT',
        topology = DT;
    case 'USB',
        topology = USB;
    case 'random_graph'
        topology = random_graph * 50;
    otherwise,
        error('no such topology!');
end

subNet.dist_matrix = topology;

topology(find(topology ~= Inf)) = init_sn;
topology(find(topology == Inf)) = 0;

subNet.bandwidth = topology;
subNet.topology = topology;
subNet.topology(find(topology~= 0)) = 1;
subNet.node_num = size(topology,1);
subNet.link_num = length(find(topology(:)~=0)) / 2;
subNet.s_matrix = cell(subNet.node_num);
for n = 1:subNet.node_num
    for m = (n+1):subNet.node_num
        if(topology(m,n) ~= 0)
            subNet.s_matrix{m,n} = zeros(1,init_sn);
            subNet.s_matrix{n,m} =  subNet.s_matrix{m,n} ;
        end
    end
end
            
subNet.cpu = zeros(subNet.node_num,1) + init_sc;
subNet.initlized_slot_number_on_each_link = init_sn;
subNet.initlized_computingcapacity_on_each_link = init_sc;
subNet.topo_name = topo_str;
save substrate_net subNet
end

