% m=norm_spec(didv,iv);
function m=norm_spec_vic(didv,iv,v);
[n1,n2]=size(iv);
r=iv./(ones(n1,1)*v);
m=didv./r;
m(1,:)=didv(1,:);

