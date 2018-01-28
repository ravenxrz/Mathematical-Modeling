D = [
    0 6 1 5 inf inf
    6 0 5 inf 3 inf
    1 50 5 5 6 4
    5 inf 5 0 inf 2
    inf  3 6 inf  0 6
    inf inf 4 2 6 0
    ];
[d,path] = Floyd(D,1,5);