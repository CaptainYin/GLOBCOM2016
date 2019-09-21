function  [controllersetarray,state]=getcoveredset(nsmsetv,node_mapping,p,potentialcset)
node_num=14;
% p=powerset(node_num);
pl=length(p);
node_comb=p;
%node_comb(i) the NO.i combination of nsmset
k=zeros(pl,1);
parfor i=1:pl
    a=zeros(node_num,1);
      cind=find(node_comb(i,:));%also the index of all node
      if(~allinpotentialcset(potentialcset,cind))
          continue;
      end
    for j=1:length(cind)
        ind=cind(j);
        sset= find(nsmsetv(ind,:));
        ssetl=length(sset);
        if(ssetl==0)
            continue;
        end
        for ii=1:ssetl
            a(sset(ii))=1;
        end
    end%a the NO.i combination can server node in node_mapping 
    if(covermappingset(a,node_mapping))
        k(i)=1;%NO.i combination can cover
    end
end
covercombind=find(k);%the index vector of combnation which can cover
cl=length(covercombind);
if(cl==0)%none of them can cover
    state=0;
    controllersetarray=[];
    return;
end
controllersetarray=cell(cl,1);
for i=1:cl
    %node_comb{covercombind(i)} the logic vector of nsmset
    logicind=node_comb(covercombind(i),:) ;
    controllerind=find(logicind);
    c_num=length(controllerind);
    controllersetarray{i}.c_num=c_num;
    controllersetarray{i}.controllerset=controllerind';
end
state=1;%find some controller combination can cover
   
        
    


            
    
