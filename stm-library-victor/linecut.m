% [v,r]=linecut(m,np);
% get the interpolated value of matrix m on a line.
% the command should run when the active window contains the result of
% the command pcolor(m) or pcolor(x,y,m).
% The line is determind by two clicks of the mouse.
% np = number of points in the interpolated line.
% v = the interpolated values
% r = the x vector of v to use in plot(r,v)


function [v,r]=linecut(m,np);

m=m';
t1=get(gca,'xlim');
t2=get(gca,'ylim');
set(gca,'xlimmode','auto','ylimmode','auto')
axis tight
xr=get(gca,'xlim');
yr=get(gca,'ylim');
set(gca,'xlim',t1,'ylim',t2)
[npx,npy]=size(m);
dx=(xr(2)-xr(1))/(npx-1);
dy=(yr(2)-yr(1))/(npy-1);
x=xr(1):dx:xr(2);
y=yr(1):dy:yr(2);

a=ginput(2);


xl1=xr(1);
xl2=xr(2);

h=line(a(:,1),a(:,2));
set(h,'color','k','linewidth',2,'linestyle','--')

dxl=(a(2,1)-a(1,1))/(np-1);
dyl=(a(2,2)-a(1,2))/(np-1);
xl=a(1,1):dxl:a(2,1);
yl=a(1,2):dyl:a(2,2);

v=zeros(1,np);

for i=1:np,
    v(i)=interp2(y,x,m,yl(i),xl(i));
end
r=sqrt((xl-xl(1)).^2+(yl-yl(1)).^2);

figure
plot(r,v)
%axis tight
grid
set(gca,'fontsize',18)
title(strrep(cd,'\','\\'))
