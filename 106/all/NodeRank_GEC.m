function GEC = NodeRank_GEC(Net)  
        d = 0.85;
        s_node_num = Net.node_num;
        cpu = Net.cpu;
        link_info_matrix = Net.bandwidth;
        temp_sum = sum(link_info_matrix);
        temp_cpu = (1 - d) * cpu / sum(cpu);
        T = zeros(s_node_num);
        for u = 1:s_node_num
            neig = find(link_info_matrix(:,u));
            for j = 1:length(neig)
                v = neig(j);
                T(u,v) = link_info_matrix(u,v) / temp_sum(v);
            end
        end    
        T = d * T;
         if(size(temp_cpu,2) ~= 1)
             temp_cpu = temp_cpu';
         end
        % GEC = (eye(s_node_num) - T)^(-1) * temp_cpu;
		MCrank = temp_cpu;
		apsilo = 0.00001;
		MCRank_ = temp_cpu + T * MCrank;
		delta = norm(MCRank_ - MCrank);
		while (delta >= apsilo)
			MCrank = MCRank_;
			MCRank_ = temp_cpu + T * MCrank;
			delta = norm(MCRank_ - MCrank);
		end
		GEC = MCRank_;
end