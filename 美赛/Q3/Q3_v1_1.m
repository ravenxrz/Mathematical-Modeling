%% 问题三-船体扰动模型求解
clear;clc;close;

syms thetaf thetaa;
i = 1;
wxd = 0;
wyd = 0.2;
wzd = 0.6;
% for wxd = 1:10
%     for wyd = 1:10
%         for wzd = 1:10
record(i) = vpasolve([thetaf == -(wxd*cos(thetaa)+wyd*sin(thetaa)),thetaa==-(wxd*sin(thetaa)*tan(thetaf)-wyd*cos(thetaa)*...
    tan(thetaf)+wzd)],[thetaf,thetaa]);
rad2deg(double(record.thetaa))
rad2deg(double(record.thetaf))
i= i + 1;
%         end
%     end
% end