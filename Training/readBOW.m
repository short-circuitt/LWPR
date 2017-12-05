function output = readBOW(fname,ND,NW)

fid = fopen(fname,'r');

if (fid<0)
    error('Failed to open file')
end

FOUNDSTART = false;

while ~feof(fid)
    s = fscanf(fid,'%c',1);
    if strcmp(s,'[')
        FOUNDSTART = true;
        break
    end
end

if ~FOUNDSTART
    error('could not find start of values')
end

s = textscan(fid, '%f,');
output = s{1};
output = reshape(output,[ND,NW])';

fclose(fid);

end
