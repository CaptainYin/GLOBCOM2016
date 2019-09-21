function new_subnet=updatesubnet(subnet,solu)
c_num=solu.c_num;
controllerset=solu.controllerset;
cnum=subnet.cnum;
for i=1:c_num
    ind=controllerset(i);
    cnum(ind)=cnum(ind)+1;
end
subnet.cnum=cnum;
new_subnet=subnet;