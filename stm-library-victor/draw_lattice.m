% draw_lattice(x0,y0,nl)
% x0,y0 position of center point of lattice. if x0=0 and y0=0 then mouse
% click is used to select a point.
% nl is the number of lattice line to draw

function draw_lattice(x0,y0,nl)
%function draw_lattice(sl1,deb1,sl2,deb2,sl3,deb3,x0,y0,nl)
load 'd:\data\sample\pt(111)\10-22-04\107\lines.mat'
if x0==0 & y0==0,
    [x0 y0]=ginput(1);
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
    plot(x,y1,x,y2,'b')
    y1=x*sl2+b2+deb2*i;
    y2=x*sl2+b2-deb2*i;
    plot(x,y1,x,y2,'b')
    y1=x*sl3+b3+deb3*i;
    y2=x*sl3+b3-deb3*i;
    plot(x,y1,x,y2,'b')
end
hold off