% show_spec2(n,gs)
% show spectroscopy of file mn_ori when n is the function input.
% gs = group size is the number of spectra to average

function show_spec_i(n,gs)
p=strrep(cd,'\','\\');
fn1=strcat('m',num2str(n),'_ori.tf0');
fn2=strcat('m',num2str(n),'_ori.cs0');
fn3=strcat('m',num2str(n),'_ori.cs1');
[vf,vb]=get_scan_voltage(n);
[fi,bi]=get_scan_current(n);

[xx,yy,tf0]=scala_read(fn1,1);
%load z
%tf0=z;
[x,y,cs0,xz]=scala_read(fn2,0);
[x,y,cs1,xz]=scala_read(fn3,0);

[qqq www]=size(cs0);
for i=1:qqq,
    cs0(i,:)=smooth(cs0(i,:));
end

m=norm_spec(cs1,cs0);

cc='rgbmykc';

[n1,n2]=size(m);
ng=floor(n1/gs);

figure
hold on
le='aa';
for i=1:ng,
    if gs>1,
        semilogy(xz,mean(m((i-1)*gs+1:(i-1)*gs+gs,:)),cc(mod(i,7)+1),'linewidth',1.5)
    else
        semilogy(xz,m(i,:),cc(mod(i,7)+1),'linewidth',1.5)
    end
    if i<100,
        if i<10,
            le(i,1:3)=strcat('00',num2str(i));
        else
            le(i,1:3)=strcat('0',num2str(i));
        end    
    else
        le(i,1:3)=strcat('',num2str(i));
    end
end
hold off
set(gca,'fontsize',18)
grid
axis tight
ht=title(strcat(p,'\\m',num2str(n),' Normalized spec, V=',num2str(vf),' V, I=',num2str(fi),' nA'));
set(ht,'fontsize',12);
legend(le)

figure
hold on
for i=1:ng,
    if gs>1,
        semilogy(xz,mean(cs1((i-1)*gs+1:(i-1)*gs+gs,:)),cc(mod(i,7)+1),'linewidth',1.5)
    else
        semilogy(xz,cs1(i,:),cc(mod(i,7)+1),'linewidth',1.5)
    end
%        le(i,1)=num2str(i);
end
hold off
set(gca,'fontsize',18)
grid
axis tight
ht=title(strcat(p,'\\m',num2str(n),' Original spec, V=',num2str(vf),' V, I=',num2str(fi),' nA'));
set(ht,'fontsize',12);
legend(le)

figure
pcolor(xx,yy,tf0)
shading interp
axis square
ht=title(strcat(p,'\\m',num2str(n),',  V=',num2str(vf),' V, I=',num2str(fi),' nA'));
set(ht,'fontsize',12);
hold on
for i=1:ng,
    %plot(x((i-1)*gs+1:(i-1)*gs+gs),y((i-1)*gs+1:(i-1)*gs+gs),strcat(cc(mod(i,7)+1),'*'),'markersize',14)
    text(x((i-1)*gs+1:(i-1)*gs+gs),y((i-1)*gs+1:(i-1)*gs+gs),num2str(i),'color','b')
end
hold off
set(gca,'fontsize',18)
colormap pink
