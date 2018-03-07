function [gk,p,num]=MMSkteam(s,k,mu1,mu2,T)
%多服务台
%s——服务台个数
%k——最大顾客等待数
%T——时间终止点
%mu1——到达时间间隔服从指数分布
%mu2——服务时间服从指数分布
% L--初始队长；
%事件表：
%   arrive_time——顾客到达事件
%   leave_time——顾客离开事件
%mintime——事件表中的最近事件
%current_time——当前时间
%L——队长
%tt——时间序列
%LL——队长序列
%c——顾客到达时间序列
%b——服务开始时间序列
%e——顾客离开时间序列
%a_count——到达顾客数
%b_count——服务顾客数
%e_count——损失顾客数
%初始化
% s=1;k=10;mu1=0.5;mu2=0.3;T=10;
arrive_time=exprnd(mu1);
leave_time=[];
current_time=0;
L=0;
LL=[L];
tt=[current_time];
c=[];
b=[];
e=[];
a_count=0;
b_count=0;
e_count=0;
%循环
while min([arrive_time,leave_time])<T
    current_time=min([arrive_time,leave_time]);
    tt=[tt,current_time];    %记录时间序列
    if current_time==arrive_time          %顾客到达子过程
        arrive_time=arrive_time+exprnd(mu1);  % 刷新顾客到达事件
        a_count=a_count+1; %累加到达顾客数
        if  L<s            %有空闲服务台
            L=L+1;        %更新队长
            b_count=b_count+1;%累加服务顾客数
            c=[c,current_time];%记录顾客到达时间序列
            b=[b,current_time];%记录服务开始时间序列
            leave_time=[leave_time,current_time+exprnd(mu2)];%产生新的顾客离开事件
            leave_time=sort(leave_time);%离开事件表排序
        elseif L<s+k             %有空闲等待位
            L=L+1;        %更新队长
            b_count=b_count+1;%累加服务顾客数
            c=[c,current_time];%记录顾客到达时间序列
        else               %顾客损失
            e_count=e_count+1;%累加损失顾客数
        end
    else                   %顾客离开子过程
        leave_time(1)=[];%从事件表中抹去顾客离开事件
        e=[e,current_time];%记录顾客离开时间序列
        if L>s    %有顾客等待
            L=L-1;        %更新队长
            b=[b,current_time];%记录服务开始时间序列
            leave_time=[leave_time,current_time+exprnd(mu2)];
            leave_time=sort(leave_time);%离开事件表排序
        else    %无顾客等待
            L=L-1;        %更新队长
        end
    end
    LL=[LL,L];   %记录队长序列
end
length(e);
length(c);
Ws=sum(e-c(1:length(e)))/length(e);
Wq=sum(b-c(1:length(b)))/length(b);
Wb=sum(e-b(1:length(e)))/length(e);
Ls=sum(diff([tt,T]).*LL)/T;
Lq=sum(diff([tt,T]).*max(LL-s,0))/T;
fprintf('到达顾客数:%d\n',a_count)%到达顾客数
fprintf('服务顾客数:%d\n',b_count)%服务顾客数
fprintf('损失顾客数:%d\n',e_count)%损失顾客数
fprintf('平均逗留时间:%f\n',Ws)%平均逗留时间
fprintf('平均等待时间:%f\n',Wq)%平均等待时间
fprintf('平均服务时间:%f\n',Wb)%平均服务时间
fprintf('平均队长:%f\n',Ls)%平均队长
fprintf('平均等待队长:%f\n',Lq)%平均等待队长
if k~=inf
    for i=0:s+k
        p(i+1)=sum((LL==i).*diff([tt,T]))/T;%队长为i的概率
        num(i) = sum(LL == i);
        %        p(i+1) = sum(LL == i)/length(LL);
        if p(i+1)~=0
            fprintf('队长为%d的概率:%f\n',i,p(i+1));
        end
    end
else
    for i=0:3*s
        p(i+1)=sum((LL==i).*diff([tt,T]))/T;%队长为i的概率
         num(i) = sum(LL == i);
        %     p(i+1) = sum(LL == i)/length(LL);
        fprintf('队长为%d的概率:%f\n',i,p(i+1));
    end
end

n=length(LL);LL(n);
LL;
%fprintf('顾客不能马上得到服务的概率:%f\n',1-sum(p(1:s)))%顾客不能马上得到服务的概率
% out=[Ws,Wq,Wb,Ls,Lq];%out=[Ws,Wq,Wb,Ls,Lq,p];
Lk = mean(LL);
gk = (k-Lk)/T;
num
end
%
% plot(c,ones(1,length(c)),'bo');
% hold on;
% plot(b,ones(1,length(b)),'ro');
% plot(e,ones(1,length(e)),'ko')
% plot(0:0.01:max([c,b,e]),ones(1,length(max([c,b,e]))),'-');
% legend('到达','开始服务','离开','线');