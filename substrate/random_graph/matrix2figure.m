% matrix2fig
topolo_load = load('substrate_net.mat','subNet');

topo_matrix = topolo_load.subNet.topology;

topolo_load_2 = load('topology_50.mat','topology');
n_x = topolo_load_2.topology.location{1};
n_y = topolo_load_2.topology.location{2};

num_nodes = length(n_x);

% Create figure
figure1 = figure;



r = 1.0;
scale = 100;
for m = 1:num_nodes
    rectangle('Position',[n_x(m) - r,n_y(m) - r, 2 * r, 2 *r],'Curvature',[1,1],'FaceColor','k');
end

for m = 1:num_nodes
    for n = 1:num_nodes
        if topo_matrix(m,n) ~= 0
            X = [n_x(m) n_x(n)];
            Y = [n_y(m) n_y(n)];
            line(X,Y,'LineWidth',1.5,'Color','k');
        end
    end
end
xlim([-1 scale])
ylim([-1 scale])

% Create axes
% axes1 = axes('Parent',figure1,'ZColor',[1 1 1],'YColor',[1 1 1],...
 %   'XColor',[1 1 1]);
set(gca,'YColor',[1 1 1],'XColor',[1 1 1]);
set(gca,'xtick',[],'xticklabel',[])
set(gca,'ytick',[],'yticklabel',[])

print(figure1,'-deps','top.eps');
% clear all
% close all
% clc