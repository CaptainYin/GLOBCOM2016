function s=controllerset(node_mapping,solu,node2mapset)
%return the number of controller and index of each node_mapping node
%index is the index of node_mapping
%the index of s in node_mapping set means
nml=length(node_mapping);
s=cell(nml,1);
for i=1:nml
    s{i}.ind=node_mapping(i);
    s{i}.mc_num=0;
    s{i}.mc_indexset=[];%index of all node
    s{i}.sc_num=0;
    s{i}.sc_indexset=[];
end
for i=1:solu.c_num
    cind=solu.controllerset(i);
   sset= node2mapset{cind}.serverset;
   ssetl=length(sset);
   if(ssetl==0)
       continue;
   end
    for j=1:ssetl
      indinm= find(node_mapping==sset(j));
        s{indinm}.mc_num=1+s{indinm}.mc_num;
        s{indinm}.mc_indexset=[s{indinm}.mc_indexset;cind];
    end
end
