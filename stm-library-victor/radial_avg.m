% [vav,v,r]=radial_avg(m,np,ra,na);
% get the interpolated value of matrix m along na lines at different angles.
% the command should run when the active window contains the result of
% the command pcolor(m) or pcolor(x,y,m).
% The center is determind by a mouse click.
% np = number of points in the interpolated line.
% ra = radius
% na = number of angles
% v = the interpolated values
% r = the x vector of v to use in plot(r,v)


function [vav,v,r]=radial_avg(m,np,ra,na);
if floor(np/2)*2==np,
    np=np+1;
end

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

b=ginput(1);


xl1=xr(1);
xl2=xr(2);
dan=2*pi/na;
v=zeros(round(na/2),np);
vav=zeros(1,np);


for i=1:round(na/2),
    an=dan*(i-1);
    a(1,1)=b(1)-ra*cos(an);
    a(2,1)=b(1)+ra*cos(an);
    a(1,2)=b(2)-ra*sin(an);
    a(2,2)=b(2)+ra*sin(an);

    h=line(a(:,1),a(:,2));
    set(h,'color','k','linewidth',2,'linestyle','--')
    dxl=(a(2,1)-a(1,1))/(np-1);
    dyl=(a(2,2)-a(1,2))/(np-1);
    if dxl~=0,
        xl=a(1,1):dxl:a(2,1);
    else,
        xl=ones(1,np)*a(1,1);
    end
    if dyl~=0,
        yl=a(1,2):dyl:a(2,2);
    else,
        yl=ones(1,np)*a(1,2);
    end
    for j=1:np,
        v(i,j)=interp2(y,x,m,yl(j),xl(j));;
    end
    vav=vav+v(i,:)+v(i,np:-1:1);
end
r=sqrt((xl-xl(1)).^2+(yl-yl(1)).^2);
vav=vav/round(na/2)/2;
figure
plot(r,v)
hold on
plot(r,vav,'r','linewidth',3)
hold off
axis tight
grid
set(gca,'fontsize',18)
title(strrep(cd,'\','\\'))


