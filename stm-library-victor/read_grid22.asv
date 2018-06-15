% [x,y,xsp,s]=read_grid(fn)
% reads spectra grid
% fn = file name
% xsp = spectrum x axis
% s = the spectrum matrix
% x,y = x and y location vectors of the grid
% readgrid22 is to read the current as well

function [x,y,xsp,s]=read_grid(fn)
[a,b]=strread(fn,'%[^.].%s');
a=char(a);
b=char(b);
p=findstr(a,'_');
fnumber=str2num(a(2:p-1));
[npx,npy]=get_grid_par(fnumber);
[xs,ys,isx,isy,p_min,p_max,r_min,r_max,ns,sps,eps,ips,sgx,sgy]=get_topo_par(a,b);
dxs=(eps-sps)/(ns-1);
xsp=-(sps:dxs:eps);
nsx=floor((isx-1)/npx)+1;
nsy=floor((isy-1)/npy)+1;
fid1=fopen(fn);
m=fread(fid1,'int8');
n=length(m);
t=m(1:2:n);
m(1:2:n)=m(2:2:n);
m(2:2:n)=t;

%extra stuff here
tt=m(1:1:n);
m(1:1:n)=m(2:1:n);
m(2:1:n)=tt

fid2=fopen('q.dat','w');
fwrite(fid2,m,'int8');
fclose('all');
fid=fopen('q.dat');
s=fread(fid,'int16');
fclose('all');
delete('q.dat');
s=reshape(s,nsx,nsy,n/2/nsx/nsy);
s=p_min+(s-r_min)*(p_max-p_min)/(r_max-r_min);
dx=xs/(isx-1);
dy=ys/(isy-1);
x=0:dx*npx:xs;
y=0:dy*npy:ys;
