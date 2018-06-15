function combine_spec(s1,s2,gs)
p=strrep(cd,'\','\\');
na1=strcat('m',num2str(s1),'_ori.cs0');
na2=strcat('m',num2str(s1),'_ori.cs1');
na3=strcat('m',num2str(s2),'_ori.cs0');
na4=strcat('m',num2str(s2),'_ori.cs1');

[x,y,z0a,xz]=scala_read(na1,0);
[x,y,z1a,xz]=scala_read(na2,0);
[x,y,z0b,xz]=scala_read(na3,0);
[x,y,z1b,xz]=scala_read(na4,0);
cs0=[z0a ; z0b];
cs1=[z1a ; z1b];
[nnn ttt]=size(z0a);
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
        %plot(xz,mean(m((i-1)*gs+1:(i-1)*gs+gs,:)),cc(mod(i,7)+1),'linewidth',1.5)
        plot(xz,m(1:nnn,:),'b','linewidth',1.5)
        plot(xz,m(nnn+1:qqq,:),'r','linewidth',1.5)
    else
        %plot(xz,m(i,:),cc(mod(i,7)+1),'linewidth',1.5)
        plot(xz,m(1:nnn,:),'b','linewidth',1.5)
        plot(xz,m(nnn+1:qqq,:),'r','linewidth',1.5)
    end
    if i<10,
        le(i,1:2)=strcat('0',num2str(i));
    else
        le(i,1:2)=strcat('',num2str(i));
    end
end
hold off
set(gca,'fontsize',18)
grid
axis tight
ht=title(strcat(p,'\\m',num2str(s1),'+',num2str(s2),' Normalized spec'));
set(ht,'fontsize',12);
legend(le)

figure
hold on
for i=1:ng,
    if gs>1,
        %plot(xz,mean(cs1((i-1)*gs+1:(i-1)*gs+gs,:)),cc(mod(i,7)+1),'linewidth',1.5)
        plot(xz,cs1(1:nnn,:),'b','linewidth',1.5)
        plot(xz,cs1(nnn+1:qqq,:),'r','linewidth',1.5)
    else
        %plot(xz,cs1(i,:),cc(mod(i,7)+1),'linewidth',1.5)
        plot(xz,cs1(1:nnn,:),'b','linewidth',1.5)
        plot(xz,cs1(nnn+1:qqq,:),'r','linewidth',1.5)
    end
%        le(i,1)=num2str(i);
end
hold off
set(gca,'fontsize',18)
grid
axis tight
ht=title(strcat(p,'\\m',num2str(s1),'+',num2str(s2),' Original spec'));
set(ht,'fontsize',12);
legend(le)

