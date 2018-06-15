% show_spec_grid(fn)
% fn = filename

function show_spec_grid(fn)
figure
[xx,yy,xs,s]=read_grid(fn);
[xx,yy,xs,s]
[a,b]=strread(fn,'%[^.].%s');
a=char(a);
b=char(b);
[x,y,z]=scala_read(strcat(a,'.tf0'),1);
pcolor(x,y,z);
axis image
shading interp
colormap pink
hold on
nx=length(xx); ny=length(yy);
bbb='   ';
for i=1:ny,
    for j=1:nx,
        qq=num2str(j-1+(i-1)*nx);
        q=text(xx(j),yy(i),qq);
        set(q,'color','b')
        nq=length(qq);
        lll(j+(i-1)*nx,:)=[bbb(1:3-nq) qq];
    end
end
hold off
set(gca,'fontsize',16)
title(strcat(cd,'\',fn))

figure
s=reshape(s,nx*ny,length(xs))';
plot(xs,s)
hl=legend(lll);
set(hl,'visible','off')
set(gca,'fontsize',16)
title(strcat(cd,'\',fn))
axis tight
