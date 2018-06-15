function lockin_para
%g=gpib('ni',0,8);
g=visa('ni','GPIB0::8::0::INSTR');
fopen(g)
set(g,'EOSMode','read&write')
set(g,'EOSCharCode','LF')

fprintf(g,'freq?')
freq=fscanf(g);
freq=str2num(freq);

fprintf(g,'slvl?')
amp=fscanf(g);
amp=str2num(amp);

fprintf(g,'sens?')
se=fscanf(g);
load sss
n=str2num(se)+1;
sense=q(n).a;

fprintf(g,'oflt?')
t=fscanf(g);
time=[10e-6 30e-6 100e-6 300e-6 1e-3 3e-3 10e-3 30e-3 100e-3 300e-3 1 3 10 30 100 300 1e3 3e3 10e3 30e3];
tconst=time(str2num(t)+1);

fclose(g)
delete(g)

ff=fopen('lockin.txt','w');
fprintf(ff,'Frequency   %f Hz\nAmplitude    %e V\nSensitivity  %s\nTime constant %f Sec',freq,amp,sense,tconst);
fclose(ff);

clear g ff

