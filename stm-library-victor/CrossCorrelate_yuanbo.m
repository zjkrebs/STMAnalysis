% CrossCorrelate_yuanbo(n, dir, level)
% Cross Correlate the topography image with the dIdV Map for file mn_ori
% dir can only take two values: 'f' means forward, 'b' means backward
% if level == 1, both topography image and dIdV map are leveled.

function CrossCorrelate_yuanbo(n,dir,level)

ftopo=strcat('m',num2str(n),'_ori.tf0');
fdidv=strcat('m',num2str(n),'_ori.tf1');
btopo=strcat('m',num2str(n),'_ori.tb0');
bdidv=strcat('m',num2str(n),'_ori.tb1');

if dir == 'f'
    [x, y, topo] = scala_read(ftopo,level);
    [x, y, didv] = scala_read(fdidv,level);
elseif dir == 'b'
    [x, y, topo] = scala_read(btopo,level);
    [x, y, didv] = scala_read(bdidv,level);
end

[m, p] = size(x);
step_size = max(x)/p;

% calculate the laplacion of the topography
lapl = 4*del2(topo, step_size);
%lapl = lapl.^2;

% figure 
% pcolor(x, y, topo)
% shading interp
% axis square
% caxis

figure
pcolor(x, y, lapl);
shading interp
axis square
%caxis([-1 1])

% do the self-correlation first
xtopo = xcorr2(topo - mean2(topo));
xdidv = xcorr2(didv - mean2(didv));
xlapl = xcorr2(lapl - mean2(lapl));

[nx_xtopo,ny_xtopo] = size(xtopo);
[nx_xdidv, ny_xdidv] = size(xdidv);
[nx_xlapl, ny_xlapl] = size(xlapl);

xtopo_ori = xtopo((nx_xtopo+1)/2, (ny_xtopo+1)/2);  % calculate the normalization factor
xdidv_ori = xdidv((nx_xdidv+1)/2, (ny_xdidv+1)/2);  % calculate the normalization factor
xlapl_ori = xlapl((nx_xlapl+1)/2, (ny_xlapl+1)/2);  % calculate the normalization factor

xtopo = xtopo/xtopo_ori;
xdidv = xdidv/xdidv_ori;
xlapl = xlapl/xlapl_ori;

% do the cross-correlation
xtopo_didv = xcorr2(topo-mean2(topo),didv-mean2(didv)) / sqrt(xtopo_ori * xdidv_ori);
xlapl_didv = xcorr2(lapl-mean2(lapl),didv-mean2(didv)) / sqrt(xlapl_ori * xdidv_ori);

% do the radio-average
rad_xtopo = radio_average_yuanbo(xtopo, 300);
rad_xdidv = radio_average_yuanbo(xdidv, 300);
rad_xlapl = radio_average_yuanbo(xlapl, 300);
rad_xtopo_didv = radio_average_yuanbo(xtopo_didv, 300);
rad_xlapl_didv = radio_average_yuanbo(xlapl_didv, 300);

figure
hold on;
plot(rad_xtopo(:,1)*step_size, rad_xtopo(:,2), 'b');
plot(rad_xdidv(:,1)*step_size, rad_xdidv(:,2), 'g');
plot(rad_xlapl(:,1)*step_size, rad_xlapl(:,2), 'k');
plot(rad_xtopo_didv(:,1)*step_size, rad_xtopo_didv(:,2), 'r');
plot(rad_xlapl_didv(:,1)*step_size, rad_xlapl_didv(:,2), 'm');
legend('topo auto','didv auto','laplacian auto','topo-didv cross', 'laplacian-didv cross');
xlabel('Radio-distance (nm)');
ylabel('Normalized correlation');
hold off;

 
% figure
% pcolor(xtopo);
% shading interp;
% axis square;

% figure
% pcolor(xdidv);
% shading interp;
% axis square;
% 
% figure
% pcolor(xtopo_didv);
% shading interp;
% axis square;
% colorbar

% write files

% write the laplacian of topo
imwrite(uint8((lapl+1.5)*100),strcat('m',num2str(n),'_',dir,'lapl.tif'),'TIFF');

% write the cross-correlation curves

% assemble the matrix
cc_matrix = [rad_xtopo(:,1)*step_size, rad_xtopo(:,2), rad_xdidv(:,2), rad_xlapl(:,2), rad_xtopo_didv(:,2), rad_xlapl_didv(:,2)];
save newfile.dat cc_matrix -ASCII