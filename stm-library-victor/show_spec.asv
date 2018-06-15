% show_spec(n)
% show spectroscopy of file mn_ori when n is the function input.

function show_spec(n)
p=strrep(cd,'\','\\');
fn1=strcat('m',num2str(n),'_ori.tf0');
fn2=strcat('m',num2str(n),'_ori.cs0');
fn3=strcat('m',num2str(n),'_ori.cs1');

[xx,yy,tf0]=scala_read(fn1,1);
[x,y,cs0,xz]=scala_read(fn2,0);
[x,y,cs1,xz]=scala_read(fn3,0);
m=norm_spec(cs1,cs0);

figure
plot(xz,mean(m(1:5,:)),xz,mean(m(6:10,:)),xz,mean(m(11:15,:)),'linewidth',2)
set(gca,'fontsize',18)
grid
axis tight
title(strcat(p,'\\m',num2str(n),' Normalized spec'))
legend('1','2','Pt')

figure
pcolor(xx,yy,tf0)
shading interp
axis square
title(strcat(p,'\\m',num2str(n)))
hold on
plot(x,y,'g*','markersize',14)
hold off
set(gca,'fontsize',18)