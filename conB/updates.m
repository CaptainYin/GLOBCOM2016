function new_s=updates(solu,cslset,s,clackset,cset)

for i=1:solu.c_num
    cind=solu.controllerset(i);%index of all node
    ind=find(cset==cind,1);%index of cset
    if(isempty(ind))
        disp('this is a bug in updates.m');
    end
   sset= cslset{ind}.serverset;
   ssetl=length(sset);
   if(ssetl==0)
       continue;
   end
    for j=1:ssetl
        indinm= find(clackset==sset(j));
          if(isempty(indinm))
                 disp('this is a second bug in updates.m');
          end
          indinm=clackset(indinm);
          for ii=1:length(s)
              if(s{ii}.ind==indinm)
                  s{ii}.sc_num=1+s{ii}.sc_num;
                  s{ii}.sc_indexset=[s{ii}.sc_indexset;cind];
                  break;
              end
          end
    end
end
new_s=s;