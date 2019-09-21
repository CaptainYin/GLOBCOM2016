function [shortest_path,k_shortest_path] = pre_calculate_paths(topo_str,K)
switch(topo_str)
    case 'six-node',
        topology = six_node;
    case 'NSF',
        topology = NSF;
    case 'DT',
        topology = DT;
    case 'USB',
        topology = USB;
end
topology(find(topology ~= Inf)) = 1;
n = size(topology,1);
shortest_path.paths = cell(n);
shortest_path.hops = zeros(n);
k_shortest_path.paths = cell(n);
k_shortest_path.hops = cell(n);
k_shortest_path.k = K;
for s = 1:n
    for d = 1:n
        if(s ~= d)
            [p,h] = dijkstra(topology,s,d);
            shortest_path.paths{s,d} = p;
            shortest_path.hops(s,d) = h;
            
            tmp_num = 1;
            temp_topo = topology;
            
            k_shortest_path.paths{s,d} = cell(K,1);
            k_shortest_path.hops{s,d} = zeros(K,1);
            
            while (tmp_num <= K)
                k_shortest_path.paths{s,d}{tmp_num} = p;
                k_shortest_path.hops{s,d}(tmp_num) = h;
                for i = 1:h
                    temp_topo(p(i),p(i+1)) = Inf;
                    temp_topo(p(i+1),p(i)) = Inf;
                end
                [p,h] = dijkstra(temp_topo,s,d);
                if(isempty(p))
                    break;
                end
                tmp_num = tmp_num + 1;
                k_shortest_path.paths{s,d}{tmp_num} = p;
                k_shortest_path.hops{s,d}(tmp_num) = h;
            end
           
        end
    end
end
end