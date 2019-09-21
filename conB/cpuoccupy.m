function new_cpu= cpuoccupy(cpu,cpuocc,solu)
cset=solu.controllerset;
for i=1:length(cset)
    cpu(cset(i))=cpu(cset(i))-cpuocc;
end
new_cpu=cpu;
