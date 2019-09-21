function allshorestdistandpath=generateallshorestpath(dist_mat)
%author:Heqing Yin 2016Äê1ÔÂ26ÈÕ21:00:28
n=size(dist_mat,1);
allshorestdistandpath=cell(n,n);
for i=1:n
    for j=i:n
        [sp,totalcost]=dijkstra(dist_mat,i,j);
        allshorestdistandpath{i,j}.shorestpath=sp;
        allshorestdistandpath{i,j}.cost=totalcost;
        allshorestdistandpath{j,i}.cost=totalcost;
        allshorestdistandpath{j,i}.shorestpath=sp(length(sp):-1:1);
    end
end