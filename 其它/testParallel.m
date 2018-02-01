function testParallel
tic
total=10^5;
parfor (i=1:total) 
    ss(i)=inSum;
end
toc
