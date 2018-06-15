% [npx,npy]=get_grid_par(fnumber)
% npx,npy = each how many points in x and y directions a spectrum will be taken.

function [npx,npy]=get_grid_par(fnumber)
fname=strcat('m',num2str(fnumber),'_ori.par');
fid=fopen(fname);
t=fgets(fid);
fclose(fid);
fid=fopen(fname);
t=fgets(fid);
while strncmp('Spectroscopy Grid Value in X',t,28)~=1,
    t=fgets(fid);
end
npx=strread(t,'Spectroscopy Grid Value in X    : %f');
t=fgets(fid);
npy=strread(t,'Spectroscopy Grid Value in Y    : %f');
