% [v,r]=linecut(m,np);
% get the interpolated value of matrix m on a line.
% the command should run when the active window contains the result of
% the command pcolor(m) or pcolor(x,y,m).
% The line is determind by two clicks of the mouse.
% np = number of points in the interpolated line.
% v = the interpolated values
% r = the x vector of v to use in plot(r,v)


function [tip,rr]=linecut(m,np);

m=m';
t1=get(gca,'xlim');
t1
gca
t2=get(gca,'ylim');
t2
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

acount=2;
b=zeros(2,2);
hobject = imline;
a = hobject.getPosition()
% a=ginputx(2);
testa = (a(1,1)-a(2,1)) + (a(1,2)-a(2,2));
while testa~=0,
    b(acount-1:acount,:)=a;
%     plot(g(1),g(2),'*')
%     if floor(p/2)*2==p,
%         line([a(p-1,1) a(p,1)],[a(p-1,2) a(p,2)])
%     end
    acount=acount+2;
    hobject = imline;
    a = hobject.getPosition();
    testa = (a(1,1)-a(2,1)) + (a(1,2)-a(2,2));
end

xl1=xr(1);
xl2=xr(2);

% h=line(a(:,1),a(:,2));
% set(h,'color','k','linewidth',2,'linestyle','--')
numberlines = size(b,1)/2;
xcords = reshape(b(:,1),2,[]);
ycords = reshape(b(:,2),2,[]);

dxl = (xcords(1,:)-xcords(2,:))/(np-1);
dyl = (ycords(1,:)-ycords(2,:))/(np-1);

% dxl=(a(2,1)-a(1,1))/(np-1);
% dyl=(a(2,2)-a(1,2))/(np-1);
% xl=a(1,1):dxl:a(2,1);
% yl=a(1,2):dyl:a(2,2);

% r=sqrt((xl-xl(1)).^2+(yl-yl(1)).^2);

v=zeros(numberlines,np);
r=zeros(numberlines,np);
figure
hold on
for j=1:numberlines,
    xl=xcords(2,j):dxl(j):xcords(1,j);
    yl=ycords(2,j):dyl(j):ycords(1,j);

    r(j,:)=sqrt((xl-xl(1)).^2+(yl-yl(1)).^2);
    for i=1:np,
        v(j,i)=interp2(y,x,m,yl(i),xl(i));
    end
end
r=r';
v=v';
% INCLUDE THESE LINES FOR AFM LINECUTTING AND TIP DECONVOLUTION
[Cm,Ind] = max(v,[],1)
bufl=1:1:numberlines;
Indy=sub2ind(size(r),Ind,bufl)
rvals=r(Indy)
vvals=v(Indy)
r=bsxfun(@minus,r,rvals);
v=bsxfun(@minus,v,Cm);

bufl=1:1:numberlines;
rvals=r(bufl)
vvals=v(bufl)

%Cm=Cm'; Ind=Ind';
plot(r,v)
%axis tight
grid
set(gca,'fontsize',18)
title(strrep(cd,'\','\\'))
hold off
