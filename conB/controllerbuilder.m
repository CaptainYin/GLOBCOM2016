function [new_solution,new_subnet]=controllerbuilder(solution,subnet,QoS,allshorestdist,p)
%author:Heqing Yin 2016Äê1ÔÂ26ÈÕ21:00:28
%update the solution and subnet
%new_solution.state=-1, 0 means link ,node mapping failed
%new_solution.state=-2 means  link ,node mapping succeed and
%controllerbuilding failed
%new_solution.state=1 means link ,node mapping succeed and  controllerbuilding  succeed
%
if(solution.state~=1)
    solution.controller=[];
    new_solution=solution;
    new_subnet=subnet;
    return;
end
node_mapping=solution.node_mapping;
potentialcset=getpotentialcontrollerset(solution.link_mapping,subnet);
node_num=subnet.node_num;
rho=0.99;
B=20000;
D_NUM=get_coefficient_reliability(rho,QoS.reliable);
BACKUP_DELAY=QoS.backup_delay;
%allshorestdistandpath=generateallshorestpath(dist_mat);
nsmset=generatesetbydelay(QoS.main_delay,node_num,node_mapping,allshorestdist,potentialcset);
nsmsetv=getnsmsetvector(nsmset);
%sortednsmset=sortnsmsetbyavgdist(nsmset,allshorestdist,B);%sortednsmset:serverset,oindex,valid
[solutionset,state]=getcoveredset(nsmsetv,node_mapping,p,potentialcset);
if(state==0)%main controller building failed
    new_solution=solution;
    new_solution.controller=[];
    new_solution.state=-2;
    new_subnet=subnet;
    return;
end
solu=getcostlesssolution(B,allshorestdist,nsmsetv,solutionset);
s=controllerset(node_mapping,solu,nsmset);%s
s=updateslavefrommaster(s,node_mapping,solu,BACKUP_DELAY,allshorestdist,D_NUM);
[state,solu,s]=updateslavefrompotential(s,solu,BACKUP_DELAY,allshorestdist,D_NUM,potentialcset,B);

subnet=updatesubnet(subnet,solu);
 new_subnet=subnet;
 solution.controller=solu;
solution.controller.s=s;
if(state==0)
    solution.state=-2;
end
new_solution=solution;

