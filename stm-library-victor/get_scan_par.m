% [xs,ys,isx,isy,p_min,p_max,r_min,r_max]=get_scan_par(fname,ext)
% This function returns the following scan parameters from the file fname.par
% xs = x scan size in nm
% ys = y scan size in nm
% isx = number of points in x direction
% isy = number of points in y direction
% p_min and p_max = minimum and maximum physical values
% r_min and r_max = minimum and maximum raw values
function [xs,ys,isx,isy,p_min,p_max,r_min,r_max]=get_scan_par(fname,ext)
fname=strcat(fname,'.par');
fid=fopen(fname);
t=fgets(fid);
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
q3=q3*2+strcmp(q2,'b');
k=0;
while k<=q3,
    k=k+1;
    t=fgets(fid);
    while length(findstr('Minimum raw value',t))==0,
        t=fgets(fid);
    end
end
r_min=strread(t,'%f;Minimum raw value');
t=fgets(fid);
r_max=strread(t,'%f;Maximum raw value');
t=fgets(fid);
p_min=strread(t,'%f;Minimum value in physical unit');
t=fgets(fid);
p_max=strread(t,'%f;Maximum value in physical unit');
fclose('all');
