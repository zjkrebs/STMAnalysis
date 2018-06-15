fylename = '5dimer_didv_data.dat';
A = importdata(fylename,',',0);
didv = A;
% reso = size(whaa,1);
% XX = 1:reso;
% YY = 1:reso;
% 
% text = fileread(fylename);
% expr = 'ScanSize: ..........';
% lengthc = regexp(text, expr, 'match');
% scoop = lengthc{1};
% framesize = sscanf(scoop,'%*s %f64')
% XX = XX*(framesize/reso);
% YY = YY*(framesize/reso);
figure
surface(didv)
shading interp
axis square
% fyleID = fopen(fylename)
% lengthc = textscan(fyleID, '%f64\rFastScanSize:')
% celldisp(lengthc)