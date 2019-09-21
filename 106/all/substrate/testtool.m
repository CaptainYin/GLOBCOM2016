%% write mat to m-file
filename = fopen('random_graph.m', 'w');
fprintf(filename,'function rg = random_graph\n');
fprintf(filename,'  rg = [');
[m,n] = size(rg);
for i = 1:m
      for j = 1:n
	     if(rg(i,j) == 0)
		    fprintf(filename,'Inf');
		 else
		    fprintf(filename,'  1');
		 end
		 if (j == n)
			 if(i ~= m)
				fprintf(filename,';\n');
			 end
		else
		    fprintf(filename,',');
		end
	 end
	 if(i == m)
	    fprintf(filename,'];\n');
	 end
end
fprintf(filename,'end\n');
fclose(filename);
	 