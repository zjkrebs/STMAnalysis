% m=norm_spec2(didv,iv,sn);
function m=norm_specs(didv,iv,sn);
[n1,n2]=size(iv);
r=iv./(ones(n1,1)*(iv(sn,:)));
m=didv./r;
m(sn,:)=didv(sn,:);

