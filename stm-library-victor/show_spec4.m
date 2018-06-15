% show_spec4(n,gs)
% for use when scanning the voltage in two directions.
% show spectroscopy of file mn_ori when n is the function input.
% gs = group size is the number of spectra to average



function show_spec4(n,gs)
p=strrep(cd,'\','\\');
fn1=strcat('m',num2str(n),'_ori.tf0');
fn2=strcat('m',num2str(n),'_ori.cs0');
fn3=strcat('m',num2str(n),'_ori.cs1');

[xx,yy,tf0]=scala_read(fn1,1);
[x,y,cs0t,xz]=scala_read(fn2,0);
[x,y,cs1t,xz]=scala_read(fn3,0);
[n1,n2]=size(cs0t);
t0=cs0t(:,[1:n2/2,n2:-1:n2/2+1])';
t1=cs1t(:,[1:n2/2,n2:-1:n2/2+1])';

t2=reshape(t0,n2/2,n1*2)';
t3=reshape(t1,n2/2,n1*2)';
[n1,n2]=size(t2);
cs0=zeros(n1,n2);
cs1=cs0;
for i=1:n1/gs/2,
    cs0(2*gs*(i-1)+1:gs*(2*i-1),:)=t2(gs*2*(i-1)+1:2:gs*2*i,:);
    cs0(gs*(2*i-1)+1:2*gs*i,:)=t2(gs*2*(i-1)+2:2:gs*2*i,:);
    cs1(2*gs*(i-1)+1:gs*(2*i-1),:)=t3(gs*2*(i-1)+1:2:gs*2*i,:);
    cs1(gs*(2*i-1)+1:2*gs*i,:)=t3(gs*2*(i-1)+2:2:gs*2*i,:);
end
xz=1:length(xz)/2;

m=norm_spec(cs1,cs0);

cc='rgbcmyk';

[n1,n2]=size(m);
ng=floor(n1/gs);

figure
hold on
for i=1:ng,
    if gs>1,
        plot(xz,mean(m((i-1)*gs+1:(i-1)*gs+gs,:)),cc(mod(i,7)+1),'linewidth',1.5)
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
for i=1:ng/2,
    plot(x((i-1)*gs+1:(i-1)*gs+gs),y((i-1)*gs+1:(i-1)*gs+gs),strcat(cc(mod(i,7)+1),'*'),'markersize',14)
end
hold off
set(gca,'fontsize',18)