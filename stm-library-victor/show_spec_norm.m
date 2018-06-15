% show_spec_norm(n,gs)
% show spectroscopy of file mn_ori when n is the function input.
% gs = group size is the number of spectra to average

function show_spec_norm(n,gs)
p=strrep(cd,'\','\\');
fn1=strcat('m',num2str(n),'_ori.tf0');
fn2=strcat('m',num2str(n),'_ori.cs0');
fn3=strcat('m',num2str(n),'_ori.cs1');

[xx,yy,tf0]=scala_read(fn1,1);
[x,y,cs0,xz]=scala_read(fn2,0);
[x,y,cs1,xz]=scala_read(fn3,0);
m=norm_spec(cs1,cs0);

cc='rgbcmyk';

[n1,n2]=size(m);
ng=floor(n1/gs);

figure
hold on
for i=1:ng,
    if gs>1,
        tt=mean(m((i-1)*gs+1:(i-1)*gs+gs,:));
        tt=tt-min(tt);
        tt=tt/max(tt);
        plot(xz,tt,cc(mod(i,7)+1),'linewidth',1.5)
    else
        plot(xz,m(i,:),cc(mod(i,7)+1),'linewidth',1.5)
    end
    if i<10,
        le(i,1:2)=strcat('0',num2str(i));
    else
        le(i,1:2)=num2str(i);
    end
end
hold off
set(gca,'fontsize',18)
grid
axis tight
title(strcat(p,'\\m',num2str(n),' Normalized spec'))
legend(le)

figure
hold on
for i=1:ng,
    if gs>1,
        plot(xz,mean(cs1((i-1)*gs+1:(i-1)*gs+gs,:)),cc(mod(i,7)+1),'linewidth',1.5)
    else
        plot(xz,cs1(i,:),cc(mod(i,7)+1),'linewidth',1.5)
    end
    %    le(i,1)=num2str(i);
end
hold off
set(gca,'fontsize',18)
grid
axis tight
title(strcat(p,'\\m',num2str(n),' Original spec'))
legend(le)

figure
pcolor(xx,yy,tf0)
shading interp
axis square
title(strcat(p,'\\m',num2str(n)))
hold on
for i=1:ng,
    plot(x((i-1)*gs+1:(i-1)*gs+gs),y((i-1)*gs+1:(i-1)*gs+gs),strcat(cc(mod(i,7)+1),'*'),'markersize',14)
end
hold off
set(gca,'fontsize',18)