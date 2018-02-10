f =   1.9557e+07;
right = 20-15.4-32.45-20*log10(f/10^6) +123 ;
La = 0.6074;
Lg =   0.0683;
delta = deg2rad(15);
hup = 150;
n = intvar(1,1);
C = [
    n*(La+Lg_static)+20*log10(hup*cos(delta)/sin(delta)*2*n) <=right;
];
z = -n;
result = optimize(C,z);
value(n)
% value(z)