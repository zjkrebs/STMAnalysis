% function [x,y,z,xz]=scala_read(fn,rs)
% This function reads a topography or spectroscopy scala file (fn) and
% retrieve the x,y vectors, the z matrix (The aquired data) and 
% the spectroscopy independent parameter (only for spectroscopy files).
% if rs=1 then z is leveled (a linear slope is removed). Relevant only in
% topography files.
% xz = spectroscopy independent parameter (Avoid it in topography files).

% as of 9/9/07 no different than normal scalaread.  This file is used to 
% test scalaread and figure out whats going on

function [x,y,z,xz]=t_read(fn,rs)
[a,b]=strread(fn,'%[^.].%s');
a=char(a);
b=char(b);
if strncmp(b,'t',1)==1,
    [xs,ys,isx,isy,p_min,p_max,r_min,r_max]=get_scan_par(a,b);
    dx=xs/(isx-1);
    dy=ys/(isy-1);
    x=0:dx:xs;
    y=0:dy:ys;
    fid1=fopen(fn);
    m=fread(fid1,'int8');
    n=isx*isy*2;
    t=m(1:2:n);
    m(1:2:n)=m(2:2:n);
    m(2:2:n)=t;
    fid2=fopen('q.dat','w');
    fwrite(fid2,m,'int8');
    fclose('all');
    fid=fopen('q.dat');
    z=fread(fid,'int16');
    fclose('all');
    delete('q.dat');
    z=reshape(z,isx,isy)';
    z=p_min+(z-r_min)*(p_max-p_min)/(r_max-r_min);
    if rs==1,
        z=remove_slope(z);
    end
elseif strncmp(b,'cs',2)==1,
    [xs,ys,isx,isy,p_min,p_max,r_min,r_max,ns,sps,eps,ips,sgx,sgy]=get_topo_par(a,b);
    dxz=(eps-sps)/(ns-1);
    xz=-(sps:dxz:eps);
    fid=fopen(fn);
    t=fgets(fid);
    while strncmp(t,';n_curves:',10)~=1,
        t=fgets(fid);
    end
    np=strread(t,';n_curves: %d');
    x=zeros(1,np);
    y=zeros(1,np);
    t=fgets(fid);
    for i=1:np,
        t=fgets(fid);
        [x(i) y(i)]=strread(t,'%f%f','delimiter',' ');
    end
    z=zeros(np,ns);
    for i=1:np,
        while strncmp(t,'BEGIN',5)~=1,
            t=fgets(fid);
        end
        for j=1:ns,
            t=fgets(fid);
            [tt z(i,j)]=strread(t,'%f%f');
        end
    end
    z=p_min+(z-r_min)*(p_max-p_min)/(r_max-r_min);
    
    fclose('all');
elseif strncmp(b,'s',1)==1,,
    [xs,ys,isx,isy,p_min,p_max,r_min,r_max,ns,sps,eps,ips,sgx,sgy]=get_topo_par(a,b);
    dx=xs/(isx-1);
    dy=ys/(isy-1);
    x=0:dx*sgx:xs;
    y=0:dy*sgy:ys;
    fid1=fopen(fn);
    m=fread(fid1,'int8');
    fclose('all');
    z=m(1:2:250000)*256+(m(2:2:250000)>0).*m(2:2:250000)+(m(2:2:250000)<0).*(m(2:2:250000)+256);
    z=reshape(z,ns,floor(isx/sgx),floor(isy/sgy));
    z=p_min+(z-r_min)*(p_max-p_min)/(r_max-r_min);
    xz=sps:ips:eps+.1*ips;
end