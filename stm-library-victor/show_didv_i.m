% show_didv_i(n,nm,gs)
% show spectroscopy of file mn_ori when n is the function input.
% nm = number of measurements at each voltage point
% gs = group size is the number of spectra to average

function show_didv_i(n,nm,gs)
p=strrep(cd,'\','\\');
fn1=strcat('m',num2str(n),'_ori.tf0');
fn2=strcat('m',num2str(n),'_ori.cs0');
fn3=strcat('m',num2str(n),'_ori.cs1');

[xx,yy,tf0]=scala_read(fn1,1);
%load z
%tf0=z;
[x,y,cs0,xz]=scala_read(fn2,0);
[x,y,cs1,xz]=scala_read(fn3,0);

[qqq www]=size(cs0);
if nm~=1,
    temp0=cs0;
    temp1=cs1;
    cs0=zeros(qqq*2,www/nm/2);
    cs1=cs0;
    for i=1:qqq,
        cs0(i,:)=mean(reshape(temp0(i,1:www/2),nm,www/nm/2));
        cs1(i,:)=mean(reshape(temp1(i,1:www/2),nm,www/nm/2));
    end
    for i=qqq+1:qqq*2,
        cs0(i,:)=mean(reshape(temp0(i-qqq,www:-1:www/2+1),nm,www/nm/2));
        cs1(i,:)=mean(reshape(temp1(i-qqq,www:-1:www/2+1),nm,www/nm/2));
    end
    
    xz=1:www/nm/2;
end

cc='rgbmykc';

[n1,n2]=size(cs1);
ng=floor(n1/gs);

figure
hold on
for i=1:ng,
    if gs>1,
        % plot(mean(cs0((i-1)*gs+1:(i-1)*gs+gs,:)),mean(cs1((i-1)*gs+1:(i-1)*gs+gs,:)),cc(mod(i,7)+1),'linewidth',1.5)
        plot(xz,mean(cs1((i-1)*gs+1:(i-1)*gs+gs,:)),cc(mod(i,7)+1),'linewidth',1.5)
    else
        % plot(cs0(i,:),cs1(i,:),cc(mod(i,7)+1),'linewidth',1.5)
        plot(xz,cs1(i,:),cc(mod(i,7)+1),'linewidth',1.5)
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
title(strcat(p,'\\m',num2str(n),'  didv'))
legend(le)

figure
hold on
for i=1:ng,
    if gs>1,
        plot(xz,mean(cs0((i-1)*gs+1:(i-1)*gs+gs,:)),cc(mod(i,7)+1),'linewidth',1.5)
    else
        plot(xz,cs0(i,:),cc(mod(i,7)+1),'linewidth',1.5)
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
title(strcat(p,'\\m',num2str(n),'  I'))
legend(le)

figure
pcolor(xx,yy,tf0)
shading interp
axis square
title(strcat(p,'\\m',num2str(n)))
hold on
for i=1:ng/2,
    plot(x((i-1)*gs+1:(i-1)*gs+gs),y((i-1)*gs+1:(i-1)*gs+gs),strcat(cc(mod(i,7)+1),'*'),'markersize',14)
end
hold off
set(gca,'fontsize',18)
colormap pink
