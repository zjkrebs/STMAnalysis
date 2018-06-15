% m2=remove_slope_el(m)
function m2=remove_slope_el(m)
[n1 n2]=size(m);
x=1:n2;
m2=zeros(size(m));
for i=1:n1,
    v=m(i,:);
    c=polyfit(x,v,1);
    v=v-c(1)*x-c(2);
    m2(i,:)=v;
end