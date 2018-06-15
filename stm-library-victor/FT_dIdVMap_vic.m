% FT_dIdVMap_vic(n)
% Fourier Transform the dIdVMap for file mn_ori, 
% adds smooth and subtraction
% p=1 for forward and 0 for backward

function FT_dIdVMap_vic(n,p)

%ftopo=strcat('m',num2str(n),'_ori.tf0');
fdidv=strcat('m',num2str(n),'_ori.tf1');
%btopo=strcat('m',num2str(n),'_ori.tb0');
bdidv=strcat('m',num2str(n),'_ori.tb1');

if p==1
    [x, y, zs2] = scala_read(fdidv,1);
else 
    [x, y, zs2] = scala_read(bdidv,1);
end
% [x1, y1, zs1] = scala_read(fdidv,1);
% zs = zs1(70:139,70:139);
% x = x1(1:70);
% y = y1(1:70);
H = fspecial('gaussian', 30, 30);
zs3 = imfilter(zs2,H,'replicate');
zs4 = zs2 - zs3;
zs1 = zs4 - mean2(zs4);
% zs1 = xcorr2(zs1);
% NOTE: using the cross-correlation doesn't seem to add much
% pcolor(x, y, zs);
% shading interp
% colormap pink
% colorbar

% pad zeros around the dI/dV map (a trick to make better ft)
np = 2;
[nx1, ny1] = size(zs1);
zs = zeros(nx1*(2*np+1), ny1*(2*np+1));
zs((np*nx1+1):((np+1)*nx1),(np*ny1+1):((np+1)*ny1)) = zs1;


% do the ft
[nx, ny] = size(zs); % size of signal
dx = max(x)/nx1;  % sampling length x
dy = max(y)/ny1;  % sampling length y
fx = 1/dx;       % sampling frequency x
fy = 1/dy;       % sampling frequency y

NFFT_x = 2^nextpow2(nx);
NFFT_y = 2^nextpow2(ny);

%fft_zs = abs(fftshift(fft2(zs, NFFT_x, NFFT_y)))/(nx*ny) ; % fft of zs
fft_zs = abs(fftshift(fft2(zs)))/(nx*ny) ; %try it without padding zeros
kx = fx*2*pi*linspace(0,1,NFFT_x);                         % this gives the real k  
ky = fy*2*pi*(pi/2)*linspace(0,1,NFFT_y);                  % this gives the real k

% plot the 2D amplitude spectrum
%figure
%pcolor(kx, ky, fft_zs(1:NFFT_x, 1:NFFT_y));
%shading interp
%hold off

% do the radio average (copied from function RadAveFT_yuanbo()
[nftx, nfty] = size(fft_zs);

% Setup the k axis
kn = 250;
kx_Max = max(kx); ky_Max = max(ky);
k_Max = sqrt(kx_Max^2 + ky_Max^2)/(2*np+1);
k_Step = k_Max/kn;
FT_P = zeros(kn,3);
for j=1:kn,
    FT_P(j,1) = k_Step*(j-0.5);
end

% Find total values of FT for each of the k
% kind of like making a histogram s
center_kx = (kx(nftx) + kx(1))/2;
center_ky = (ky(nfty) + ky(1))/2;
for i=1:nftx,
    for j=1:nfty,
        k = sqrt((kx(i)-center_kx)^2 + (ky(j)-center_ky)^2);
        ind = int32(k/k_Step);
        if ind <= kn
            if ind == 0
                FT_P(1,2) = FT_P(1,2) + fft_zs(i,j);
                FT_P(1,3) = FT_P(1,3) + 1;
            else
                FT_P(ind,2) = FT_P(ind,2) + fft_zs(i,j);
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

% % Output the matrxi as figure and data file
figure
plot(FT_P(:,1),FT_P(:,2));

FT_Out = FT_P(:,1:2);
save newfile.dat FT_Out -ASCII