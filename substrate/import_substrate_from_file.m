function subNet = import_substrate_from_file(filename)

fid = fopen(filename);
if(fid == -1)
    error('can not open the file');
    
end
Header = str2num(fgetl(fid));

node_num = Header(1);
link_num = Header(2);

matrix = zeros(node_num);

n_x = zeros(node_num,1);
n_y = zeros(node_num,1);
cpu = zeros(node_num,1);

index = 1;
while (index <= node_num)
    temp = str2num(fgetl(fid));
    
    n_x(index) = temp(1);
    n_y(index) = temp(2);
    cpu(index) = temp(3);
    
    index = index + 1;
end

index = 1;
while (index <= link_num)
    temp = str2num(fgetl(fid));
    
    s = temp(1) + 1;
    d = temp(2) + 1;
    
    bandwidth = temp(3);
    
    matrix(s,d) = bandwidth;
    matrix(d,s) = bandwidth;
    index = index + 1;
end


fclose(fid);

subNet.node_num = node_num;
subNet.link_num = link_num;
subNet.n_x = n_x;
subNet.n_y = n_y;
subNet.cpu = cpu;
subNet.matrix = matrix;
end

