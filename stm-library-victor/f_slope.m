function s=f_slope(a,m)
[nx ny]=size(m);
x=1:nx;
y=1:ny;
[xx yy]=ndgrid(x,y);
q=a(1)*xx+a(2)*yy+a(3);
s=sum(sum((q-m).^2));
