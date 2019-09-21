function deg = degree(topo)
    
	  node_num = size(topo,1);
	  deg = zeros(node_num,1);
	  
	  for i = 1:node_num
	     deg(i) = length(find(topo(:,i) ~= 0));
	  end
end