% m2=remove_slope(m1)
% This function levels an image by substracting from it a linear plane.
% m2 is the leveled matrix. 
function m2=remove_slope(m1)
a=fminsearch('f_slope',[0 0 0],[],m1);
[nx ny]=size(m1);
x=1:nx;
y=1:ny;
[xx yy]=ndgrid(x,y);
m2=m1-(a(1)*xx+a(2)*yy+a(3));
