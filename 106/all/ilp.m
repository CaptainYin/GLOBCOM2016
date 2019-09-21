function    [mlevel,nodeoeo,weightsum]=ilp(cell_set,weight_mat,set_power,link_id,node_id)
weightsum=0;
mlevel=[];
nodeoeo=[];
[row,col]=size(cell_set);
A=[];
% path=path(find(path));
for jj=1:col
    for ii=1:row
	    cellset=cell2mat(cell_set(ii,jj));
		a=zeros(1,length(link_id));
        if ~isempty(cellset)
		   index1=find(link_id==cellset(1));
		   a(index1:index1+length(cellset)-1)=1;
		   A(:,(jj-1)*row+ii)=a';
        else
           A(:,(jj-1)*row+ii)=a';
        end
    end
end
b=ones(length(link_id),1);
c=[];
for jj=1:col
    for ii=1:row
        c((jj-1)*row+ii,1)=weight_mat(ii,jj);
    end
end
c=c';
A1=eye(length(c));
A=[A;A1];
b=[b;zeros(length(c),1)];
[x,fval]= BranchBound(c,-A,-b,[],[]);
if fval== 0     % no fesiable solution
   weightsum=inf;
   return;
end
for jj=1:col
    for ii=1:row
        if x((jj-1)*row+ii,1)~=0
		   mlevel=[mlevel,ii];
		   nodeoeo=[nodeoeo,node_id(jj)];
           weightsum=weightsum+set_power(ii,jj);
		end
    end
end
nodeoeo=nodeoeo(2:end);
end	
		
		


