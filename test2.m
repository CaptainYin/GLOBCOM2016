z=zeros(10000,1);
for i=1:10000
z(i)=normrnd(3000,100);
end
hist(z,1000);