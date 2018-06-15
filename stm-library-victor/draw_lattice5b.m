% draw_lattice5b(x0,y0,nl)
% x0,y0 position of center point of lattice. if x0=0 and y0=0 then mouse
% click is used to select a point.
% nl is the number of lattice line to draw

function draw_lattice5b(x0,y0,nl)
load 'D:\Yossi\documents\Papers\Co on Pt\matlab\10-22-04\107\lines.mat'
sl1=sl3;
deb1=-deb3;
sl3=(sl1*deb2+sl2*deb1)/(deb1+deb2);
deb3=abs(deb2/(sl1-sl2)*(sl1-(sl1*deb2+sl2*deb1)/(deb2+deb1)));
al=abs(atan(sl1)-atan(sl2))/2+abs(atan(sl1));
d=abs(deb2/(sl1-sl2)*sqrt(1+sl1^2))*2/3;

if x0==0 & y0==0,
    [x0 y0]=ginput(1);
    x0=x0+d*cos(al)
    y0=y0+d*sin(al)
end

b1=y0-sl1*x0;
b2=y0-sl2*x0;
b3=y0-sl3*x0;
ttt=get(gca,'xlim');
xa=ttt(1);
xb=ttt(2);
dx=(xb-xa)/100;
x=xa:dx:xb;
hold on
for i=0:nl,
    y1=x*sl1+b1+deb1*i;
    y2=x*sl1+b1-deb1*i;
    plot(x,y1,'g',x,y2,'g','linewidth',1.1)
%    if i==1,
%        plot(x,y1,'c','linewidth',1.5)
%    end
    y1=x*sl2+b2+deb2*i;
    y2=x*sl2+b2-deb2*i;
    plot(x,y1,'g',x,y2,'g','linewidth',1.1)
%    if i==3,
%        plot(x,y1,'c','linewidth',1.5)
%    end
    y1=x*sl3+b3+deb3*i; 
    y2=x*sl3+b3-deb3*i;
    plot(x,y1,'g',x,y2,'g','linewidth',1.1)
%    if i==5,
%        plot(x,y1,'c','linewidth',1.5)
%    end
end
bb1=b1+1*deb1;
bb2=b2+3*deb2;
bb3=b3+5*deb3;
xx1=(bb3-bb1)/(sl1-sl3);
xx2=(bb2-bb1)/(sl1-sl2);
xx3=(bb3-bb2)/(sl2-sl3);
yy1=sl1*xx1+bb1;
yy2=sl1*xx2+bb1;
yy3=sl3*xx3+bb3;
patch([xx1 xx2 xx3],[yy1 yy2 yy3],'g','erasemode','background','edgecolor','g')
bb1=b1+2*deb1;
bb2=b2-0*deb2;
bb3=b3+1*deb3;
xx1=(bb3-bb1)/(sl1-sl3);
xx2=(bb2-bb1)/(sl1-sl2);
xx3=(bb3-bb2)/(sl2-sl3);
yy1=sl1*xx1+bb1;
yy2=sl1*xx2+bb1;
yy3=sl3*xx3+bb3;
patch([xx1 xx2 xx3],[yy1 yy2 yy3],'b','erasemode','background','edgecolor','b')
hold off