function pos=findfisrtdiff(met0,met1)
for i=1:10000
     if(met0.state(i)~=met1.state(i))
        pos=i;
        return;
     end
     if met1.state(i)==-1||met1.state(i)==0||met1.state(i)==-2
         continue;
     end
    disp(i);
  
    if(met0.controller{i, 1}.controllerset~=met1.controller{i, 1}.controllerset)
        pos=i;
        return;
    end
     if( length(met1.controller{i, 1}.s)~= length(met0.controller{i, 1}.s))
          pos=i;
          return;
      end
    for j=1:length(met1.controller{i, 1}.s)
      if( met1.controller{i, 1}.s{j}.ind~= met0.controller{i, 1}.s{j}.ind)
          pos=i;
          return;
      end
    end
end