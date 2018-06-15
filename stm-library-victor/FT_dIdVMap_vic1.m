% FT_dIdVMap_yuanbo(n)
% Fourier Transform the dIdVMap for file mn_ori

function FT_dIdVMap_yuanbo(n)

ftopo=strcat('m',num2str(n),'_ori.tf0');
fdidv=strcat('m',num2str(n),'_ori.tf1');
btopo=strcat('m',num2str(n),'_ori.tb0');
bdidv=strcat('m',num2str(n),'_ori.tb1');

% [x, y, zs1] = scala_read(bdidv,1);
[x, y, zs1] = scala_read(fdidv,1);
% zs = zs1(70:139,70:139);
% x = x1(1:70);
% y = y1(1:70);
zs = zs1 - mean2(zs1);
% pcolor(x, y, zs);
% shading interp
% colormap pink
% colorbar

[X,Y] = meshgrid(-74:75,-74:75);
Z=X.^2+Y.^2;
Z=sqrt(Z);
zs=cos((15*2*pi*Z)./(max(size(Z))));

% some parameters for the ft
[nx, ny] = size(zs);
dx = max(x)/nx;
dy = max(y)/ny;
kx_Max = 2*pi/dx;
ky_Max = 2*pi/dy;

dkx = kx_Max/nx;
dky = ky_Max/ny;


% pad zeros around the dI/dV map (a trick to make better ft)
np = 3;
pad_zs = zeros(nx*(2*np+1), ny*(2*np+1));
pad_zs((np*nx+1):((np+1)*nx),(np*ny+1):((np+1)*ny)) = zs;

% do the fourier transform
ft_zs = abs(fftshift(fft2(pad_zs)));
dkx = dkx / (2*np+1);
dky = dky / (2*np+1);

kx = dkx:dkx:kx_Max; kx = kx - kx_Max/2;
ky = dky:dky:ky_Max; ky = ky - ky_Max/2;
size(ft_zs)
% figure
% pcolor(kx, ky, ft_zs);
% shading interp
% colormap pink
% colorbar

% do the radio average (copied from function RadAveFT_yuanbo()
[nftx, nfty] = size(ft_zs);

% Setup the k axis
kn = 200;
k_Max = sqrt(kx_Max^2 + ky_Max^2)/(2*np+1);
k_Step = k_Max/kn;
FT_P = zeros(kn,3);
for j=1:kn,
    FT_P(j,1) = k_Step*(j-0.5);
end

% Find total values of FT for each of the k
% kind of like making a histogram s
center_kx = (nftx+1)/2;
center_ky = (nfty+1)/2;
for i=1:nftx,
    for j=1:nfty,
        k = sqrt(((i-center_kx)*dkx)^2 + ((j-center_ky)*dky)^2);
        ind = int32(k/k_Step);
        if ind <= kn
            if ind == 0
                FT_P(1,2) = FT_P(1,2) + ft_zs(i,j);
                FT_P(1,3) = FT_P(1,3) + 1;
            else
                FT_P(ind,2) = FT_P(ind,2) + ft_zs(i,j);
                FT_P(ind,3) = FT_P(ind,3) + 1;
            end
        end
    end
end

% Take the average of each 'bin' to get FT value
for j=1:kn,
    if FT_P(j,3) > 0
        FT_P(j,2) = FT_P(j,2)/FT_P(j,3);
    end
end

% Output the matrxi as figure and data file
figure
plot(FT_P(:,1), FT_P(:,2));

FT_Out = FT_P(:,1:2);
%save newfile FT_Out -ASCII