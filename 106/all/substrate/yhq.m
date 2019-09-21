count=0;
d=zeros(14,14);
 c=cell(14,14);
 band=zeros(1,200);
for i=1:14
    for j=1:14
        if(dist(i,j)<inf)
           d(i,j)=1;
           count=count+1;
           c{i,j}=band;
        end
    end
end
