function e=iscpuenough(cpu,cpuocc,ind)
dl=length(ind);
for i=1:dl
    if(cpu(ind(i))<cpuocc)
        e=0;
        return;
    end
end
e=1;