[x,y,xsp,s]=read_grid('m10_ori.sf1');
hf=figure;
set(gcf,'position',[420   379   646   587])
for i=1:100,
    ha1=subplot(2,1,1);
    ss=reshape(s(:,:,i),20,20);
    ss=ss-min(min(ss));
    ss=ss/max(max(ss));
    pcolor(x,y,ss)
    axis image
    set(gca,'fontsize',16)
    shading interp
    set(ha1,'xtick',[0 4 8],'ytick',[0 4 8])
    xlabel('X  (nm)')
    ylabel('Y  (nm)')
    caxis([0    1])
    hc=colorbar;
    set(hc,'ytick',[0.2 0.5 0.8],'fontsize',14)

    ha2=subplot(2,1,2);
    plot(xsp,reshape(mean(mean(s)),100,1),'linewidth',2)
    set(gca,'fontsize',16)
    xlabel('E-E_f  (eV)')
    ylabel('dI/dV')
    set(gca,'fontsize',16,'xlim',[-.45 .25])
    hl=line([xsp(i) xsp(i)],[0 2]);
    set(hl,'color','k','linestyle','--','linewidth',2)

    set(ha1,'position',[0.1300    0.5189    0.7750    0.4061])
    set(ha2,'position',[0.3529    0.1103    0.4443    0.2738])
    f(i)=getframe(hf);
end
movie2avi(f,'mov01.avi','fps',3)
