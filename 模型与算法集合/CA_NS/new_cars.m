function [plaza,v,vmax]=new_cars(plaza,v,probc,probv,VTypes)
[L,W]=size(plaza);
%     plaza(2,3)=1;v(2,3)=1;vmax(2,3)=2;
%     plaza(3,3)=1;v(3,3)=1;vmax(3,3)=1;
%     plaza(4,3)=1;v(4,3)=1;vmax(4,3)=1;
%     plaza(5,3)=1;v(5,3)=1;vmax(5,3)=2;
vmax=zeros(L,W);
for lanes=2:W-1;
    for i=1:L;
        if(rand<=probc)%在该位置随机产生一个车子
            tmp=rand;
            plaza(i,lanes)=1;
            for k=1:length(probv)%随机生成一个车子应该有的最大车速
                if(tmp<=probv(k))
                    vmax(i,lanes)=VTypes(k);%判断属于哪个挡的车速并赋值
                    v(i,lanes)=ceil(rand*vmax(i,lanes));%对当前位置随机赋予一个初速度
                    break;
                end
            end
        end
    end
end


%处理未达到密度要求的车辆需求
needn=ceil((W-2)*L*probc);
number=size(find(vmax~=0),1);
if(number<needn)%如果密度小于预期
    while(number~=needn)
        i=ceil(rand*L);
        lanes=floor(rand*(W-2))+2;
        if(plaza(i,lanes)==0)
            plaza(i,lanes)=1;
            for k=1:length(probv)%随机生成一个车子应该有的最大车速
                if(tmp<=probv(k))
                    vmax(i,lanes)=VTypes(k);%判断属于哪个挡的车速并赋值
                    v(i,lanes)=ceil(rand*vmax(i,lanes));%对当前位置随机赋予一个初速度
                    break;
                end
            end
            number=number+1;
        end
    end
end
if(number>needn)%如果密度大于预期
    temp=find(plaza==1);
    for k=1:number-needn;
        i=temp(k);
        plaza(i)=0;
        vmax(i)=0;
        v(i)=0;
    end
end
end