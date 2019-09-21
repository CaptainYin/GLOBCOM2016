function LEC = node_rank_lec_layered(node_capacity,topology)
   
  degree_layer = degree(topology);
  LEC = node_capacity .* degree_layer;

end