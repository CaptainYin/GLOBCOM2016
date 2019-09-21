function   [state,new_s]=addslave(s,node_mapping,solu,index1,BACKUP_DELAY,allshorestdistandpath,lack_num)
%for the specially unrelable node
%index1 is the specially unrelable node index in node_mapping
%need at leaset lack_num slave controllers
%state 1:secced -1:failed
ind=node_mapping(index1);
busc=zeros(solu.c_num,1);%1 represent can be slave controller
for i=1:solu.c_num
    if(~isempty(find(s{index1}.mc_indexset==solu.controllerset(i),1)))
        continue;
    end
    if(allshorestdistandpath(ind,solu.controllerset(i))<=BACKUP_DELAY)
        busc(i)=1;
    end
end
sc_index=find(busc);%index of solu.controllerset
% if(isempty(sc_index))
%     state=-1;
%     new_s=s;
%     return;
% end
 busc_num=length(sc_index);
 if(busc_num<lack_num)
        state=-1;
        new_s=s;
        % for this node can not add salve controller in controller set
        %goto add controller
        return;
 end
 %sort the back_up slave controller by allshorestdistandpath
dist=zeros(busc_num,1);indsc=zeros(busc_num,1);
for i=1:busc_num
    indsc(i)=solu.controllerset(sc_index(i));
    dist(i)=allshorestdistandpath(indsc(i),ind);
end
[~,oindex]=sort(dist);
sorted=cell(busc_num,1);
for i=1:busc_num
    sorted{i}.index=indsc(oindex(i));
    %index of all node
    sorted{i}.cost=dist(oindex(i));
end
s{index1}.sc_num=s{index1}.sc_num+lack_num;
s{index1}.sc_indexset=zeros(lack_num,1);
for i=1:lack_num
    s{index1}.sc_indexset(i)=sorted{i}.index;
end
state=1;
new_s=s;
% for this node can add salve controller in controller set
%goto next  unrelable node NULL->accept





















    