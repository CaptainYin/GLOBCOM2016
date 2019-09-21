function [solution,subNet]=debug(solution1,subNet1,solution2,subNet2,req)
for i=1:14
    if(subNet1.cpu(i)~=subNet2.cpu(i))
         disp([req,'CPU not EQ']);
            pause;
    end
    for j=i+1:14
        if (~isempty(subNet1.s_matrix{i,j}))&&~isempty(find((subNet1.s_matrix{i,j}==subNet2.s_matrix{i,j})~=1, 1))
            disp([req,'s_matrix not EQ']);
            pause;
        end
    end
end
if(solution1.state~=solution2.state)
     disp([req,'solution.state not EQ']);
            pause;
end
if(solution1.state==1)
    if(solution1.node_mapping~=solution2.node_mapping)
            disp([req,'solution.nodemapping not EQ']);
                     pause;
    end
    if(length(solution1.link_mapping)~=length(solution2.link_mapping))
        disp([req,'linkmappinglength not EQ']);
                     pause;
    end
    for i=1:length(solution1.link_mapping)
        if(solution1.link_mapping{i}~=solution2.link_mapping{i})
             disp([req,'linkmapping not EQ']);
                     pause;
        end
    end
end
solution=solution1;
subNet=subNet1;