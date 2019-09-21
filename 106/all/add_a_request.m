function [time_list_o,requests_save_o] =  add_a_request(requests,solution,time_list,requests_save)
%% add a request to the request-saving list according to the chronological order
depart_time = requests.time_depart;% request depart time
r_save.node_num = requests.node_num;% node number of the request
r_save.link_num = requests.link_num;% link number of the request
r_save.node_mapping = solution.node_mapping;% node mappng vector
r_save.link_mapping = solution.link_mapping;% link mapping vector
r_save.allocated_starting = solution.allocated_starting_index;% slot allocated starting and ending indices
r_save.allocated_ending = solution.allocated_ending_index;
r_save.cpu = requests.cpu(1);% computing resources requirements
r_save.controllerset=solution.controller.controllerset;
requests_save_o = {};
if (isempty(time_list))
    time_list_o = [time_list,depart_time];
    requests_save_o = [requests_save_o,r_save];
    return;
end

requests_save_o = [requests_save_o,r_save];
insert_index = find(time_list > depart_time,1);

if(isempty(insert_index))
    time_list_o = [time_list,depart_time];
    requests_save_o = [requests_save,requests_save_o];
else if(insert_index == 1)
        time_list_o = [depart_time,time_list];
        requests_save_o = [requests_save_o,requests_save];
    else
        time_list_o = [time_list(1:(insert_index-1)),depart_time,time_list((insert_index):end)];
        requests_save_o = [requests_save(1:(insert_index-1)),requests_save_o,requests_save((insert_index):end)];
    end
end
end