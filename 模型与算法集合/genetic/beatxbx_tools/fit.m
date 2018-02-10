% feixianxing guihua ceshi 
function f = fit(x,y)
    n =length(x);
    f = zeros(n,1);
    f(-x.*y>10) = 300;
    f(1.5+x.*y - x - y > 0) = 3000;
    index = f== 0;
    f(index) = exp(x(index)).*(4*x(index).^2+2*y(index).^2 + 4*x(index).*y(index) + 2*y(index) + 1);
end