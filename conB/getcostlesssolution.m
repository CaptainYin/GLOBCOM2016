function solu=getcostlesssolution(B,allshorestdistandpath,nsmsetv,solutionset)
%solu has field :c_num,cost,controllerset
solution_num=length(solutionset);
solusetcost=zeros(solution_num,1);
parfor i=1:solution_num
    c_num=solutionset{i}.c_num;
     cost=zeros(c_num,1);
     cset=solutionset{i}.controllerset;
    for j=1:c_num
        ind=cset(j);
        sset=find(nsmsetv(ind,:));
        ssetl=length(sset);
        if(ssetl==0)
            continue;
        end
        for ii=1:ssetl
           cost(j)=allshorestdistandpath(ind,sset(ii))+cost(j);
        end
        cost(j)=cost(j)/ssetl;
    end
    solusetcost(i)=sum(cost)+B*c_num;
end
[~,oind]=sort(solusetcost);
% newsolutionset=cell(solution_num,1);
% for i=1:solution_num
%     oindex=oind(i);
%     newsolutionset{i}=solutionset{oindex};
%     newsolutionset{i}.cost=solusetcost(oindex);
% end
solu=solutionset{oind(1)};
solu.cost=solusetcost(oind(1));
