% show_didv(n,na)
% show dI/dV map of file mn_ori when n is the function input.
% na is the number of points to average at the beginning of the scan.

function show_didv2(n,na)

[vf,vb]=get_scan_voltage(n);
[fi,bi]=get_scan_current(n);
p=strrep(cd,'\','\\');
fn1=strcat('m',num2str(n),'_ori.tf0');
fn2=strcat('m',num2str(n),'_ori.tb0');
fn3=strcat('m',num2str(n),'_ori.tf1');
fn4=strcat('m',num2str(n),'_ori.tb1');

[xx,yy,tf04]=scala_read(fn1,1);
figure
pcolor(xx,yy,tf04)
shading interp
axis square
title(strcat(p,'\\m',num2str(n),' topo V=',num2str(vf,'%4.3f'),' V',' I=',num2str(fi,'%4.2f'),' nA'))
set(gca,'fontsize',18)

[xx,yy,tb04]=scala_read(fn2,1);

[xx,yy,tf14]=scala_read(fn3,0);
[xx,yy,tb14]=scala_read(fn4,0);

[n1,n2]=size(tf14);

%na=3;
%for i=1:n1,
%    tf14(i,1:na)=tf14(i,na+1);
%    tb14(i,n2-na+1:n2)=tb14(i,n2-na);
%end

figure
%tf14=(tf14-26.438)/130.32;
pcolor(xx,yy,tf14)
shading interp
axis square
title(strcat(p,'\\m',num2str(n),' dI/dV V=',num2str(vf,'%4.3f'),' V',' I=',num2str(fi,'%4.2f'),' nA'))
set(gca,'fontsize',18)
a=caxis;
colorbar;
hold on
contour(xx,yy,tf04,'k')
hold off
caxis(a)

figure
tb14=(tb14-18.7)/59.33;
mean(mean(tb14))
pcolor(xx,yy,tb14)
shading interp
axis square
title(strcat(p,'\\m',num2str(n),' dI/dV V=',num2str(vb,'%4.3f'),' V',' I=',num2str(bi,'%4.2f'),' nA'))
set(gca,'fontsize',18)
a=caxis;
colorbar;
hold on
contour(xx,yy,tb04,'k')
hold off
caxis(a)
