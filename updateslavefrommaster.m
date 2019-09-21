function new_s=updateslavefrommaster(s,node_mapping,solu,BACKUP_DELAY,allshorestdistandpath,D_NUM)
nml=length(node_mapping);
c_num=solu.c_num;
cset=solu.controllerset;
for i=1:nml
    if(s{i}.mc_num+s{i}.sc_num>=D_NUM)
        continue;
    end
    for j=1:c_num
        if(~isempty(find(s{i}.mc_indexset==cset(j),1)))
            continue;
        end
        if(allshorestdistandpath(node_mapping(i),cset(j))<=BACKUP_DELAY)
            s{i}.sc_num=s{i}.sc_num+1;
            s{i}.sc_indexset=[s{i}.sc_indexset;cset(j)];
        end
    end
end
new_s=s;
            