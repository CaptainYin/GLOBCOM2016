alls=generateallshorestpath(subNet.dist_matrix);
all=zeros(14,14);
alla=zeros(14*14,1);
for i=1:14
    for j=1:14
        all(i,j)=alls{i,j}.cost;
        alla((i-1)*14+j)=alls{i,j}.cost;
    end
end
hist(alla,10);
