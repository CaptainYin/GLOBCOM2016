function [subNet_save,allshorestdist]=preprocesssubnet(subNet)
%%
% plus GC,alpha,degree,allshorestnormalized to subNet
%  
% 
% 

 subNet.GC = 0;
 subNet=controllerlimit(subNet,20);
 topo=subNet.topology;
 deg=degree(topo);
 subNet.degree=deg;
 node_num=subNet.node_num;
 subNet.alpha=sum(deg)/node_num;

 allshorestdistandpath=generateallshorestpath(subNet.dist_matrix);
 allshorestdist=getdist(allshorestdistandpath);
 maxd=max(max( allshorestdist));
 mind=min(min(allshorestdist));
 subNet.allshorestnormalized=(allshorestdist-mind)/(maxd-mind);
  subNet_save = subNet;% save to calculate utilization
 