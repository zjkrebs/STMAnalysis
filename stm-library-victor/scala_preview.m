function scala_preview( path, row, colum)
%SCALA_PREVIEW Preview the scala images in the specified path
%  

% set default paht, row and colum if not specified
try filepath = strcat(path, '\*.tf0');
catch filepath = '.\*.tf0';
end
try row = strread(row);
catch row = 3;
end
try colum = strread(colum);
catch colum = 3;
end

% list the directory
sfiles = dir(filepath);

% plot all images in figures
figurenumber = ceil(length(sfiles)/(colum*row));
for j = 1:figurenumber,
    figure;
    for i = (1+(j-1)*colum*row):(j*colum*row),
        if i<(length(sfiles)+1),
            simage = sfiles(i).name;
            [x,y,z] = scala_read(simage,0);
            [n,s] = strread(simage,'m%d%s');
            [fv,bv] = get_scan_voltage(n);
            [fi,bi] = get_scan_current(n);
            subplot(row,colum,i-(j-1)*colum*row), pcolor(x, y, z);
            colormap pink;
            shading interp;
            axis square
            stitle = strrep(simage,'_ori.tf0','');
            stitle = strcat(stitle, sprintf('\nF:%.1fV %.2fnA\nB:%.1fV %.2fnA',fv, bv, fi, bi));
            %if exist(strrep(simage,'tf0','tf1'),'file'),
            %    stitle = strcat(stitle, 'dI/dV map');
            %end
            if exist(strrep(simage,'tf0','cs0'),'file'),
                stitle = strcat(stitle, sprintf('\nw/ Spectrum'));
            end
            title(stitle);
        end
    end
end