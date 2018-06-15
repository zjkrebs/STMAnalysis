% [xs,ys,isx,isy,p_min,p_max,r_min,r_max,ns,sps,eps,ips,sgx,sgy]=get_topo_par(fname,ext)
% This function returns the following scan parameters from the file fname.par
% xs = x scan size in nm
% ys = y scan size in nm
% isx = number of points in x direction
% isy = number of points in y direction
% p_min and p_max = minimum and maximum physical values
% r_min and r_max = minimum and maximum raw values
% ns = number of spectroscopic points
% sps,eps,ips = start, end, incremental point spectroscopy
% sgx = spectroscopy grid x
% sgy = spectroscopy grid y
function [xs,ys,isx,isy,p_min,p_max,r_min,r_max,ns,sps,eps,ips,sgx,sgy]=get_topo_par(fname,ext)
fname=strcat(fname,'.par');

% finding the number of spectroscopy channels.
fid=fopen(fname);
t=fgets(fid);
cc=0;
while t~=-1,
    if length(findstr('Spectroscopy Channel',t))~=0,
        cc=cc+1;
    end
    t=fgets(fid);
end
fclose(fid);

fid=fopen(fname);
t=fgets(fid);


while strncmp('Field X Size in nm',t,18)~=1,
    t=fgets(fid);
end
xs=strread(t,'Field X Size in nm              :%f;[nm]');
t=fgets(fid);
ys=strread(t,'Field Y Size in nm              :%f;[nm]');
t=fgets(fid);
isx=strread(t,'Image Size in X                 : %f');
t=fgets(fid);
isy=strread(t,'Image Size in Y                 : %f');





[q1 q2 q3]=strread(ext,'%1c%1c%d');
if strcmp(q2,'b')==1,
    q3=q3+cc/2;
end
k=0;
while k<=q3,
    k=k+1;
    t=fgets(fid);
    while length(findstr('Spectroscopy Channel',t))==0,
        t=fgets(fid);
    end
end
while length(findstr('Minimum raw value',t))==0,
    t=fgets(fid);
end
r_min=strread(t,'%f;Minimum raw value');
t=fgets(fid);
r_max=strread(t,'%f;Maximum raw value');
t=fgets(fid);
p_min=strread(t,'%f;Minimum value in physical unit');
t=fgets(fid);
p_max=strread(t,'%f;Maximum value in physical unit');


while length(findstr('Number of spectroscopy points',t))==0,
    t=fgets(fid);
end
ns=strread(t,'%f;Number of spectroscopy points');
t=fgets(fid);
sps=strread(t,'%f;Start point spectroscopy');
t=fgets(fid);
eps=strread(t,'%f;End point spectroscopy');
t=fgets(fid);
ips=strread(t,'%f;Increment point spectroscopy');

while length(findstr('Spectroscopy Grid Value in X    :',t))==0,
    t=fgets(fid);
end
sgx=strread(t,'Spectroscopy Grid Value in X    :%d');
while length(findstr('Spectroscopy Grid Value in Y    :',t))==0,
    t=fgets(fid);
end
sgy=strread(t,'Spectroscopy Grid Value in Y    :%d');

fclose('all');