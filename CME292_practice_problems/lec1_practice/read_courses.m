function  [g] = read_courses(fname)

g = cell(0,6);

fid = fopen(fname);
count=0;
while 1
    tline = fgetl(fid);
    if ~ischar(tline), break, end;

    count=count+1;
    if mod(count,7)==0, continue, end;
    g{ceil(count/7),mod(count,7)} = tline;
    if mod(count,7)==4
        g{ceil(count/7),mod(count,7)}=str2double(g{ceil(count/7),mod(count,7)});
    end
end
fclose(fid);

end