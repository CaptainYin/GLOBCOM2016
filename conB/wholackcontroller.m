function [clackset,lack_num]=wholackcontroller(s,D_NUM)
sl=length(s);
clackset=zeros(14,1);
lack_num=zeros(14,1);
for i=1:sl
    if( s{i}.mc_num+s{i}.sc_num<D_NUM)
        clackset(s{i}.ind)=1;
        lack_num(s{i}.ind)=D_NUM-(s{i}.mc_num+s{i}.sc_num);
    end
end
clackset=find(clackset);