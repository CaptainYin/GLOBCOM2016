for load_id=1:1
load_filename = sprintf('request-set-%d',load_id * 10);
load_files = load(load_filename);
req = load_files.requests;
N = 10000;
request=req.request;
for i = 1:N
        QoS.reliable=0.99+rand/100;% (0.99 ,1)
        QoS.backup_delay=normrnd(600,100);
        QoS.main_delay=normrnd(300,100);
        request(i).QoS=QoS;
end
req.request = request;
requests=req;
save(['C:\Users\“Û∫Œ«‰\Documents\MATLAB\all\requests\dt\plusqos\requests-set-',num2str(req.erlangs),'plusQoS.mat'],'requests');
end