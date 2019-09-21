function index=getunrelablenode(s,D_NUM)
%return the node index in node_mapping which mc_num<D_NUM
nml=length(s);
index=zeros(nml,1);
for i=1:nml
    if(s{i}.mc_num<D_NUM)
        index(i)=1;
    end
end
index=find(index);