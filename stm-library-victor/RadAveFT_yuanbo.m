% This function takes FT data (as an XYZ matrix)
% and performs a radius average. The output
% is FT power density v.s. k

function RadAveFT_yuanbo(tfile)

FT = load(tfile);
[n, m] = size(FT);

% Setup the k axis
kn = 100;
k_Max = 1;
k_Step = k_Max/kn;
FT_P = zeros(kn,3);
for j=1:kn,
    FT_P(j,1) = k_Step*(j-0.5);
end

center = (FT(128,1)+FT(129,1))/2;

for i=1:n,
    k = sqrt((FT(i,1)-center)^2 + (FT(i,2)-center)^2);
    ind = int32(k/k_Step);
    if ind <= kn
        FT_P(ind,2) = FT_P(ind,2) + FT(i,3);
        FT_P(ind,3) = FT_P(ind,3) + 1;
    end
end

for j=1:kn,
    if FT_P(j,3) > 0
        FT_P(j,2) = FT_P(j,2)/FT_P(j,3);
    end
end

figure
plot(FT_P(:,1), FT_P(:,2));
