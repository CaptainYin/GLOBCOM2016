function allshorestdist=getdist(allshorestdistandpath)
allshorestdist=zeros(14,14);
for i=1:14
    for j=1:14
        allshorestdist(i,j)=allshorestdistandpath{i,j}.cost;
    end
end