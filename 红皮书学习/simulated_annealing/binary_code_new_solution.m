function solution = binary_code_new_solution(solution,num,d,restriction)
% 二进制编码：随机点反转+头尾交替变换产生新解
% 输入：解+数量
% 输出： 新解
% 本函数不可用，只是提供思路，具体应用可见sa-01knapsack

%产生随机扰动
tmp=ceil(rand.*num);
solution(1,tmp)=~solution(1,tmp);
p = 1;
%检查是否满足约束
while 1
    q=(solution*d <= restriction);
    if ~q
        p=~p;	%实现交错着逆转头尾的第一个1
        tmp=find(solution==1);
        if p
            solution(1,tmp(1))=0;    % 变成0还是1视情况而定
        else
            solution(1,tmp(end))=0;
        end
    else
        break
    end
end
end
end