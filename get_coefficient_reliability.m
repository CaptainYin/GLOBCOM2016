function d_num=get_coefficient_reliability(rho,relay)
%author:Heqing Yin 2016��1��26��21:00:28
d_num=ceil(log(1-relay)/log(1-rho));