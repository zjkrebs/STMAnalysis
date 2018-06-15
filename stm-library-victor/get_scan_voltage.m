% [vf,vb]=get_scan_voltage(n)
% get the forward and backward voltages
% for the scan in the file mn_ori

function [vf,vb]=get_scan_voltage(n)
fn=strcat('m',num2str(n),'_ori.par');
fid=fopen(fn);
p=[];
while length(p)==0,
    t=fgets(fid);
    p=findstr(t,'Gap Voltage');
end

vf=strread(t,'Gap Voltage                     : %f ;[V] (Forward)');
t=fgets(fid);
vb=strread(t,'%f;[V] (Backward)');
fclose('all');