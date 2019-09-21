function c=coverlackset(a,clackset,lack_num)
for i=1:length(clackset)
    if(a(clackset(i))<lack_num(clackset(i)))
        c=0;
        return;
    end
end
c=1;