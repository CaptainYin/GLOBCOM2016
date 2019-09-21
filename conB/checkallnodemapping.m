function [acc,new_solu,new_s]=checkallnodemapping(node_mapping,s,D_NUM,allshorestdistandpath,MAIN_DELAY,BACKUP_DELAY,solu,sortednsmset)
 %index=getunrelablenode(s,D_NUM);
 % index of node_mapping
 nml=length(node_mapping);
 for i=1:nml
     if(s{i}.mc_num>=D_NUM)%update s after add newcontroller
         continue;
     end
     ind=node_mapping(i);
     %try addslave
     lack_num=D_NUM-s{i}.mc_num;
     [state,s]=addslave(s,node_mapping,solu,i,BACKUP_DELAY,allshorestdistandpath,lack_num);
     if(state==1)
         continue;
     end
     [solu,acc,s]=addcontroller(MAIN_DELAY,ind,i,sortednsmset,solu,allshorestdistandpath,lack_num,s,nml,node_mapping);
     if(acc==0)
         new_solu=solu;
         new_s=s;
         return;
     end
 end
  new_solu=solu;
  new_s=s;
  acc=1;
         
 