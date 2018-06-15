% [fi,bi]=get_scan_current(n)
% get the forward and backward currents
% for the scan in the file mn_ori

function [fi,bi]=get_scan_current(n)
fn=strcat('m',num2str(n),'_ori.par');
fid=fopen(fn);
p=[];
while length(p)==0,
    t=fgets(fid);
    p=findstr(t,'Feedback Set');
end

fi=strread(t,'Feedback Set                    : %f ;[nA] (Forward)');
t=fgets(fid);
bi=strread(t,'%f;[nA] (Backward)');
fclose('all');