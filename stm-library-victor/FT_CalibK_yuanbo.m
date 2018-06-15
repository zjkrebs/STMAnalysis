% FT_Calib_yuanbo(n)
% Calibrate the 2D k vector of the Fourier Transform function fft2() in
% matlab

function FT_CalibK

% create an artificial image 
kx_art = 0.8; ky_art = 0.8;
nx_art = 150; ny_art = 150;
Lx_art = 80; Ly_art = 80;
x = linspace(0,Lx_art,nx_art);
y = linspace(0,Ly_art,ny_art);

[X,Y] = meshgrid(x,y);
zs2 = sin(X.*kx_art)+cos(Y.*ky_art);
mesh(zs2)

% [x1, y1, zs1] = scala_read(fdidv,1);
% zs = zs1(70:139,70:139);
% x = x1(1:70);
% y = y1(1:70);
zs1 = zs2 - mean2(zs2);
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

fft_zs = abs(fftshift(fft2(zs, NFFT_x, NFFT_y)))/(nx*ny) ; % fft of zs
kx = fx*sqrt(pi/2)*linspace(0,1,NFFT_x);
ky = fy*sqrt(pi/2)*linspace(0,1,NFFT_y);

%plot the 2D amplitude spectrum
figure
pcolor(kx, ky, fft_zs(1:NFFT_x, 1:NFFT_y));
shading interp
hold off

% do the radio average (copied from function RadAveFT_yuanbo()
[nftx, nfty] = size(fft_zs);

% Setup the k axis
kn = 500;
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
plot(FT_P(:,1), FT_P(:,2));

FT_Out = FT_P(:,1:2);
save newfile.dat FT_Out -ASCII