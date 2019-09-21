function [state,new_solu,new_s]=updateslavefrompotential(s,solu,BACKUP_DELAY,allshorestdistandpath,D_NUM,potentialcset,B)
%state 1 :building succeed
%0:building failed
%select all the node_mapping node s{i}.mc_num+s{i}.sc_num<D_NUM  and
%return lack_num,clackset
[clackset,lack_num]=wholackcontroller(s,D_NUM);
if(isempty(clackset))
    state=1;%not exist
    new_solu=solu;
    new_s=s;
    return;
end
%select all the potential controller from potentialcsetind and ignore the
%node already in the solu.controllerset
cset=getcontrollerfromp(solu.controllerset,potentialcset);
%and judge if the set isempty,and then get serverset
if(isempty(cset))
    state=0;
    new_solu=solu;
    new_s=s;
    return;
end
%get the cset server clackset set and get the avgcost
cslset=getserversetbydelay(BACKUP_DELAY,cset,clackset,allshorestdistandpath,B);
%finally do combination and select then get rid of the combination which can not
%cover setA and then sort by cost and select the costless
[subsolu,state]=getcoveredandcostless(cset,clackset,cslset,lack_num);
if(state==0)
    new_solu=solu;
    new_s=s;
    return;
end
%now update s according to subsolu
s=updates(subsolu,cslset,s,clackset,cset);
solu.c_num=subsolu.c_num+solu.c_num;
solu.cost=subsolu.cost+solu.cost;
solu.controllerset=[solu.controllerset;subsolu.controllerset'];
new_solu=solu;
new_s=s;
state=1;
%check s{i}.mc_num+s{i}.sc_num<D_NUM
