% [r,vav,v]=line_avg(m,np,nlines);
% r = position vector
% vav = averaged line
% v = all lines
% m = the data matrix
% np = number of points
% nlines = number of lines

function [r,vav,v]=line_avg(m,np,nlines);
%m=xcz17b; np=100; nlines=5;
vav=0; v=0;
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

hold on
p1(1,:)=ginput(1);
plot(p1(1,1),p1(1,2),'*');
p1(2,:)=ginput(1);
plot(p1(2,1),p1(2,2),'*');
if p1(2,1)<p1(1,1),
    temp1=p1(2,1); temp2=p1(2,2);
    p1(2,1)=p1(1,1); p1(2,2)=p1(1,2);
    p1(1,1)=temp1; p1(1,2)=temp2;
end
p2(1,:)=ginput(1);
plot(p2(1,1),p2(1,2),'*');
p2(2,:)=ginput(1);
plot(p2(2,1),p2(2,2),'*');
if p2(2,1)<p2(1,1),
    temp1=p2(2,1); temp2=p2(2,2);
    p2(2,1)=p2(1,1); p2(2,2)=p2(1,2);
    p2(1,1)=temp1; p2(1,2)=temp2;
end

c1=polyfit([p1(1,1) p1(2,1)],[p1(1,2) p1(2,2)],1);
c2=polyfit([p2(1,1) p2(2,1)],[p2(1,2) p2(2,2)],1);
a=(c1(1)+c2(1))/2;
b1=(p1(1,2)+p1(2,2)-c1(1)*(p1(1,1)+p1(2,1)))/2;
b2=(p2(1,2)+p2(2,2)-c2(1)*(p2(1,1)+p2(2,1)))/2;

x1s=p1(1,1); x1e=p1(2,1);
x2s=p2(1,1); x2e=p2(2,1);
dx1=(x1e-x1s)/(np-1);
dx2=(x2e-x2s)/(np-1);
x1=x1s:dx1:x1e;
x2=x2s:dx2:x2e;
y1=a*x1+b1;
y2=a*x2+b2;
r=sqrt((x1-x1(1)).^2+(y1-y1(1)).^2);
db=(b2-b1)/(nlines-1);
dx=(x2(1)-x1(1))/(nlines-1);;
xx=x1; yy=y1; b=b1;
for i=1:nlines,
    plot(xx,yy)
    b=b+db;
    xx=xx+dx;
    yy=a*xx+b;
    for j=1:np,
        v(i,j)=interp2(y,x,m,yy(j),xx(j));
    end
end
hold off
vav=mean(v);

figure
plot(r,vav,'linewidth',2);

