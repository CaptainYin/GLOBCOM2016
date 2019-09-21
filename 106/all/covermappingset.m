function h=covermappingset(v,node_mapping)
%reurn 1 mean can cover
nml=length(node_mapping);
for i=1:nml
    if(v(node_mapping(i))==0)
        h=0;
        return;
    end
end
h=1;

        