function solution = natural_code_new_solution(solution,amount)
% 自然编码：根据二交换或三交换生成新解
% 输入：solution当前解，amount当前解长度，之所以不采用length(solution)是为了加快迭代
% 输出:   solution新解

if (rand < 0.5)	% 随机决定是进行两交换还是三交换
    % 两交换
    ind1 = 0; ind2 = 0;
    while (ind1 == ind2)
        ind1 = ceil(rand.*amount);
        ind2 = ceil(rand.*amount);
    end
    tmp1 = solution(ind1);
    solution(ind1) = solution(ind2);
    solution(ind2) = tmp1;
else
    % 三交换
    ind1 = 0; ind2 = 0; ind3 = 0;
    while (ind1 == ind2) || (ind1 == ind3) ...
            || (ind2 == ind3) || (abs(ind1-ind2) == 1)
        ind1 = ceil(rand.*amount);
        ind2 = ceil(rand.*amount);
        ind3 = ceil(rand.*amount);
    end
    tmp1 = ind1;tmp2 = ind2;tmp3 = ind3;
    % 确保ind1 < ind2 < ind3
    if (ind1 < ind2) && (ind2 < ind3)
    elseif (ind1 < ind3) && (ind3 < ind2)
        ind2 = tmp3;ind3 = tmp2;
    elseif (ind2 < ind1) && (ind1 < ind3)
        ind1 = tmp2;ind2 = tmp1;
    elseif (ind2 < ind3) && (ind3 < ind1)
        ind1 = tmp2;ind2 = tmp3; ind3 = tmp1;
    elseif (ind3 < ind1) && (ind1 < ind2)
        ind1 = tmp3;ind2 = tmp1; ind3 = tmp2;
    elseif (ind3 < ind2) && (ind2 < ind1)
        ind1 = tmp3;ind2 = tmp2; ind3 = tmp1;
    end
    
    tmplist1 = solution((ind1+1):(ind2-1));
    solution((ind1+1):(ind1+ind3-ind2+1)) = ...
        solution((ind2):(ind3));
    solution((ind1+ind3-ind2+2):ind3) = ...
        tmplist1;
end
end