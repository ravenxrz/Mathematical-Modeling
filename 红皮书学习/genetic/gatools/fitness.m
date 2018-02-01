function f = fitness(x)
if x(1)>=-10 && x(1)<= 10 && x(2) >= -10 && x(2) <= 10
    f=x(1)*sin(x(2))+ x(2)*sin(x(1));
else
    f = inf;
end