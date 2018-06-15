% [sl,deb]=av_line2();

function [sl,deb]=av_line2();

hold on
q=1;
o=optimset('TolFun',1e-8,'TolX',1e-8);
g=ginput(1);
while length(g)~=0,
    p(q)=1;
    while length(g)~=0,
        x(q,p(q))=g(1);
        y(q,p(q))=g(2);
        plot(x(q,p(q)),y(q,p(q)),'*')
        p(q)=p(q)+1;
        g=ginput(1);
    end
    g=ginput(1);
    q=q+1;
end
c1=polyfit(x(1,:),y(1,:),1);
c2=polyfit(x(2,:),y(2,:),1);

pp=fminsearch('lines_std',[c1(1),c1(2),c2(2)-c1(2)],o,x,y,p-1)

for i=1:q-1,
    xx=x(i,1:p(i)-1);
    yy=pp(1)*xx+pp(2)+(i-1)*pp(3);
    plot(xx,yy);
end

hold off

sl=pp(1);
deb=pp(3);