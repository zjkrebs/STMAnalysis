function s=lines_std(p,xat,yat,pt)
a=p(1);
b=p(2);
deb=p(3);
[n1 n2]=size(xat);
s=0;

for i=1:n1,
    x=xat(i,1:pt(i));
    y=yat(i,1:pt(i));
    yy=a*x+b+(i-1)*deb;
    s=s+mean(sqrt(sum((yy-y).^2)));
end