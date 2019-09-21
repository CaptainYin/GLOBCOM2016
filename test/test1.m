succeed=0;
tic;
subNet.GC=0;
file=fopen('out.txt','w');
for i=1:1
[solution,osubNet] = vone_gec_lasp(requests.request(i),subNet);
[state,solu,s]=controllerbuilder(solution,subNet,QoS);
if(state==1)
    succeed=succeed+1;
end
c=toc;
fprintf(file,'%d  succeed: %d  time:%f\n',i,succeed,c);
end
fcolse(file)
succeedratio= succeed/10000;