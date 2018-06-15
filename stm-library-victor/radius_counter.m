leng=0
r=r+1;
for x=1:239
    for y=1:239
        val=z(x,y);
        q=r(x,y);
        Q=round(q);
        leng(Q)=val/(pi*2*q+.1);
    end
end
r=r-1;
leng;