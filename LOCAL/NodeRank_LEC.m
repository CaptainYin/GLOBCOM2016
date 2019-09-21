function LEC = NodeRank_LEC(Net)
%% basic node ranking
cpu = Net.cpu;

link_info_matrix = Net.bandwidth;

temp_sum = sum(link_info_matrix)';

LEC = cpu .* temp_sum;
end