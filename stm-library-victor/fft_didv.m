[x,y,z1]=scala_read('m58_ori.tb1',1);
%[x,y,z2]=scala_read('m20_ori.tb1',1);
H = fspecial('gaussian', 25, 25);
z1 = imfilter(z1,H,'replicate');
z1=z1-mean2(z1);
%z2=z2-mean2(z2);
xz1=xcorr2(z1);
%xz2=xcorr2(z2);

%figure
%pcolor(xz1);
%axis square
%shading interp

%figure
%pcolor(xz2);
%axis square
%shading interp
fxz1=abs(fftshift(fft2(xz1)));
%fxz2=abs(fftshift(fft2(xz2)));

sz1=size(fxz1);
xxx=(-1)*floor(sz1(1)/2):1:floor(sz1(1)/2);
yyy=(-1)*floor(sz1(1)/2):1:floor(sz1(1)/2);
[t,r,z]=cart2pol(xxx,yyy,fxz1);
radius_counter
leng1=leng;
leng1=(1/max(leng1))*leng1

%[t,r,z]=cart2pol(X,Y,fxz2(xx,yy));
%radius_counter
%leng2=leng;
%leng2=(1/max(leng2))*leng2

%plot(leng1,'red')

%plot(leng2,'blue')
figure;
pcolor(fxz1);
shading interp;
axis square;
colorbar;
%figure;
%pcolor(fxz2)
%shading interp;
%axis square;
%colorbar;