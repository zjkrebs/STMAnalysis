% m=norm_spec(didv,iv);
% xxx normalize with respect to the second guy
function m=norm_spec(didv,iv);
[n1,n2]=size(iv);
r=iv./(ones(n1,1)*(iv(6,:)));
m=didv./r;
m(1,:)=didv(1,:);

