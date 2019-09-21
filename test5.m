all_metrics=all_metrics1;
succnum=0;
contoll=0;
for i=1:10000
    if(all_metrics.state(i)==1)
         succnum=succnum+1;
          contoll=contoll+all_metrics.controller{i, 1}.c_num;
    end
end
avgcon=contoll/succnum;