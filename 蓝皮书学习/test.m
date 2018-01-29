D = load('dist2.txt');
[row,col] = size(D);
for i = 1:row
    for j = 1:col
        if(D(i,j) == 0 && i~= j)
            D(i,j) = inf;
        end
    end
end