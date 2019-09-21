function p=powerset(n)
%
p=zeros(2^n-1,n);
for i=1:2^n-1
    c=dec2bin(i);
    cl=length(c);
    for j=1:cl
        if(c(j)=='1')
        p(i,j+n-cl)=1;
        end
    end
end
    