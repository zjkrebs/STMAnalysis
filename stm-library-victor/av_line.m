% [sl,deb]=av_line();

function [sl,deb]=av_line();
a=zeros(1,2);
p=1;
hold on
g=ginput(1);
while length(g)~=0,
    a(p,:)=g;
    plot(g(1),g(2),'*')
    if floor(p/2)*2==p,
        line([a(p-1,1) a(p,1)],[a(p-1,2) a(p,2)])
    end
    p=p+1;
    g=ginput(1);
end
hold off
[n1 n2]=size(a);
c=zeros(n1/2,2);
d=0;
for i=1:2:n1,
    t=polyfit([a(i,1) a(i+1,1)],[a(i,2) a(i+1,2)],1);
    c((i+1)/2,1)=t(1);
    c((i+1)/2,2)=t(2);
end
sl=mean(c(:,1));
deb=mean(diff(c(:,2)));
