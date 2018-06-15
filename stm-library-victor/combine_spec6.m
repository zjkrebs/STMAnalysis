% function combine_spec6(s1,s2,v1,v2,v3,v4,v5,v6,sn)
% plot the differences as well
% sn = spectrum number to normalize from

function combine_spec6(s1,s2,v1,v2,v3,v4,v5,v6,sn)
p=strrep(cd,'\','\\');
na1=strcat('m',num2str(s1),'_ori.cs0');
na2=strcat('m',num2str(s1),'_ori.cs1');
na3=strcat('m',num2str(s2),'_ori.cs0');
na4=strcat('m',num2str(s2),'_ori.cs1');

[x,y,z0a,xz]=scala_read(na1,0);
[x,y,z1a,xz]=scala_read(na2,0);
[x,y,z0b,xz]=scala_read(na3,0);
[x,y,z1b,xz]=scala_read(na4,0);

cs0=[z0a([v1 v2 v3],:) ; z0b([v4 v5 v6],:)];
cs1=[z1a([v1 v2 v3],:) ; z1b([v4 v5 v6],:)];

[nnn ttt]=size(z0a([v1 v2 v3],:));
[qqq www]=size(cs0);
for i=1:qqq,
    cs0(i,:)=smooth(cs0(i,:));
end

m=norm_spec2(cs1,cs0,sn);

[n1,n2]=size(m);

figure
hold on
le='aa';
        plot(xz,m(1:nnn,:),'b','linewidth',1.5)
        plot(xz,m(nnn+1:qqq,:),'r','linewidth',1.5)
hold off
set(gca,'fontsize',18)
grid
axis tight
ht=title(strcat(p,'\\m',num2str(s1),'+',num2str(s2),' Normalized spec'));
set(ht,'fontsize',12);
%legend(le)

figure
hold on
le='aa';
xxx1=length(v1);
xxx2=length([v1 v2]);
xxx3=length([v1 v2 v3]);
xxx4=length([v1 v2 v3 v4]);
xxx5=length([v1 v2 v3 v4 v5]);
xxx6=length([v1 v2 v3 v4 v5 v6]);
        plot(xz,mean(m(1:xxx1,:)),'b',xz,mean(m((xxx1+1):xxx2,:)),'r','linewidth',1.5)
        plot(xz,mean(m((xxx2+1):xxx3,:)),'g','linewidth',1.5)
        plot(xz,mean(m((xxx3+1):xxx4,:)),'b:',xz,mean(m((xxx4+1):xxx5,:)),'r:','linewidth',2.5)
        plot(xz,mean(m((xxx5+1):xxx6,:)),'g:','linewidth',2.5)
%        plot(xz,mean(m(1:xxx1,:))-mean(m((xxx3+1):xxx4,:)),'g',xz,mean(m((xxx1+1):xxx2,:))-mean(m((xxx4+1):xxx5,:)),'g:','linewidth',1.5)
%        plot(xz,mean(m((xxx2+1):xxx3,:))-mean(m((xxx5+1):xxx6,:)),'g:','linewidth',2.5)
        hold off
set(gca,'fontsize',18)
grid
axis tight
ht=title(strcat(p,'\\m',num2str(s1),'+',num2str(s2),' Normalized spec'));
set(ht,'fontsize',12);
legend('1','2','3','4','5','6')

figure
plot(xz,mean(m(1:xxx1,:))-mean(m((xxx3+1):xxx4,:)),'b',xz,mean(m((xxx1+1):xxx2,:))-mean(m((xxx4+1):xxx5,:)),'r','linewidth',1.5)
hold on
plot(xz,mean(m((xxx2+1):xxx3,:))-mean(m((xxx5+1):xxx6,:)),'g','linewidth',1.5)
%plot(xz(2:length(xz)),diff(mean(m(1:xxx1,:))-mean(m((xxx3+1):xxx4,:))),'c','linewidth',1.5)
hold off
set(gca,'fontsize',18)
grid
axis tight
ht=title(strcat(p,'\\m',num2str(s1),'+',num2str(s2),' normalized spec'));
set(ht,'fontsize',12);

figure
plot(xz,(mean(m(1:xxx1,:))-mean(m((xxx3+1):xxx4,:)))./(mean(m(1:xxx1,:))+mean(m((xxx3+1):xxx4,:))),'b'...
    ,xz,(mean(m((xxx1+1):xxx2,:))-mean(m((xxx4+1):xxx5,:)))./(mean(m((xxx1+1):xxx2,:))+mean(m((xxx4+1):xxx5,:))),'r','linewidth',1.5)
hold on
plot(xz,(mean(m((xxx2+1):xxx3,:))-mean(m((xxx5+1):xxx6,:)))./(mean(m((xxx2+1):xxx3,:))+mean(m((xxx5+1):xxx6,:))),'g','linewidth',1.5)
%plot(xz(2:length(xz)),diff(mean(m(1:xxx1,:))-mean(m((xxx3+1):xxx4,:))),'c','linewidth',1.5)
hold off
set(gca,'fontsize',18)
grid
axis tight
ht=title(strcat(p,'\\m',num2str(s1),'+',num2str(s2),'Asymmetry normalized spec'));
set(ht,'fontsize',12);

figure
hold on
        plot(xz,cs1(1:nnn,:),'b','linewidth',1.5)
        plot(xz,cs1(nnn+1:qqq,:),'r','linewidth',1.5)
hold off
set(gca,'fontsize',18)
grid
axis tight
ht=title(strcat(p,'\\m',num2str(s1),'+',num2str(s2),' original spec'));
set(ht,'fontsize',12);
