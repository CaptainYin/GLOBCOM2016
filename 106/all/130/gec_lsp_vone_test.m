%% test llr transparent VONE on DT topology
clear all;
rootpath=cd;
reqfolder = [rootpath,'\requests\dt\plusqos'];%change path 2016年1月26日16:23:35
resultfolder=[rootpath,'\all_metrixs'];
subnetfolder=[rootpath,'\substrate\dt\substrate_net.mat'];
files = dir(reqfolder);
request_set_num = 0;
reqfilename = {};
 subNet_load = load(subnetfolder,'subNet');% load initial substrate network
 subNet = subNet_load.subNet;
 [subNet_save,allshorestdist]=preprocesssubnet(subNet);
 po=powerset(14);
for f_id = 1:length(files)
     [path_name,file_name,ext] = fileparts(files(f_id).name);
     if(strcmp(ext,'.mat'))
          request_set_num = request_set_num + 1;
          reqfilename = [reqfilename;[reqfolder,'\',files(f_id).name]];
     end
end
VNE_REQUEST_TOTAL_NUM = 10000;  % total request number
for test_name_request_folder_id = 1:request_set_num
   subNet=  subNet_save ;
    tic;
    % performance metics definitions
    request_total_count = 0; % total number of requests that have arrived til now.
    request_accept_count = 0;% number of accepted requests til now.
    acceptance_ratio = 0;% temp acceptance ratio
    % performance metrics saving variables
    all_metrics.time_arrival = zeros(VNE_REQUEST_TOTAL_NUM,1);% arrival time of each request
    all_metrics.acceptance_ratio = zeros(VNE_REQUEST_TOTAL_NUM,1);% acceptance ratio at the  time when each request arrives
    all_metrics.state = zeros(VNE_REQUEST_TOTAL_NUM,1);% accepted state of each request
	all_metrics.hop_vector = cell(VNE_REQUEST_TOTAL_NUM,1);
	all_metrics.dist_vector = cell(VNE_REQUEST_TOTAL_NUM,1);
    all_metrics.controller=cell(VNE_REQUEST_TOTAL_NUM,1);
    time_list = []; % record the depart time of each arrived request
    requests_save = {};% record the requests that are still hosted on the substarte network
    node_mapping_fail_count = 0;% number of requests whose emebding failed in node mapping stage.
    controllerbuilding_fail_count=0;% number of requests whose emebding succeed but controllerbuilding failed
    link_mapping_fail_count = 0;% number of requests whose emebding failed in link mapping stage.
    % currPath = fileparts(mfilename('fullpath'));
   
    % str_req_folder = sprintf('requests/dt/request-set-%d.mat',test_name_request_folder_id * 10);
    str_req_folder = reqfilename{test_name_request_folder_id};
    disp( str_req_folder);toc;
    requests_load = load(str_req_folder,'requests');
    requests_set = requests_load.requests;
    if ~(requests_set.erlangs == 10)
        continue;
    end
    % start testing
    for req = 1:VNE_REQUEST_TOTAL_NUM
        if(mod(req,100)==0)
            disp(req);toc;
          SysTime = now;
          str = datestr(SysTime,'mmmm_dd_yyyy_HH_MM');
        save([resultfolder,'\',all_metrics.method,num2str(req),'-',num2str(requests_set.erlangs),'-',str,'.mat'],'all_metrics');
        end
        requests = requests_set.request(req);% load a request
        t_arrival = requests.time_arrival;
        %%%%
        %----------------------------------------------
        % calculate that if there are requests that need to leave before this request's arrival, and then
        % release the resources they occupied.
        %----------------------------------------------
        if(~isempty(time_list))
            r_need_depart = find(time_list <= t_arrival);
            if(~isempty(r_need_depart))
                for ii = 1:length(r_need_depart)
                    r_request_folder_id = r_need_depart(ii);
                    %modify remove_requests,request_save,all_matrixs
                    %2016年1月28日11:47:11 @Heqing yin
                    subNet =  remove_requests(requests_save{r_request_folder_id},subNet);
                end
                % delete the items
                time_list(r_need_depart) = [];
                requests_save(r_need_depart) = [];
            end
        end
        %**********************************************************************************************************************************
        [solution,subNet] = vone_lec_lsp(requests,subNet);%0:node_mapping failed -1:link_mapping failed -2:controllerbuilding failed
        [solution,subNet]=controllerbuilder(solution,subNet,requests.QoS,allshorestdist,po);
        all_metrics.method = 'vone_lec_lsp';
        %**********************************************************************************************************************************
        request_total_count =  request_total_count + 1;
        all_metrics.state(req) = solution.state;
        if(solution.state == 1)% if this request is accpeted
		    all_metrics.hop_vector{req} = solution.hop_vector;
			all_metrics.dist_vector{req} = solution.dist_vector;
            all_metrics.controller{req} = solution.controller;
            [time_list,requests_save] =  add_a_request(requests,solution,time_list,requests_save);% save this request
            request_accept_count = request_accept_count + 1;
        else % if it failed
            if(solution.state == 0)% node mapping failed
                node_mapping_fail_count = node_mapping_fail_count + 1;      
            else
                if(solution.state == -1)% link mapping failed
                    link_mapping_fail_count = link_mapping_fail_count + 1;
                else
                   controllerbuilding_fail_count= controllerbuilding_fail_count+1;
                end
            end
        end
        % Update and save acceptance ratio and save current total revenue and cost
        acceptance_ratio = request_accept_count / request_total_count;
        all_metrics.time_arrival(req) = t_arrival;
        all_metrics.acceptance_ratio(req) = acceptance_ratio;
    end
    
    % Save node maping failure number and link mapping failure number
    all_metrics.node_mapping_fail = node_mapping_fail_count;
    all_metrics.link_mapping_fail = link_mapping_fail_count;
    all_metrics.controllerbuilding_fail_count= controllerbuilding_fail_count;
    all_metrics.request_accept_count=request_accept_count;
    all_metrics.erlangs = requests_set.erlangs;
    time_ex = toc;
    all_metrics.time_execution = time_ex;
    SysTime = now;
    str = datestr(SysTime,'mmmm_dd_yyyy_HH_MM');
    save([resultfolder,'\',all_metrics.method,num2str(requests_set.erlangs),'-',str,'.mat'],'all_metrics');
    fprintf('Erlangs: %d\nBlocking Probability: %.2f\n',all_metrics.erlangs,(10000- all_metrics.request_accept_count)/10000);
end