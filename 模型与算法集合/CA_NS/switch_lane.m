function [plaza,v,vmax]=switch_lane(plaza,v,vmax,gap,LUP,LDOWN);
    [L,W]=size(plaza);%车道大小，包括边界
    changeL=zeros(L,W);%可向左变道
    changeR=zeros(L,W);%可向右变道
    %测量是否可以向左变道
    for lanes=2:W-2;
        temp=find(plaza(:,lanes)==1);
        nn=length(temp); 
        for k=1:nn;
            i=temp(k);
            if(v(i,lanes)>gap(i,lanes)&LUP(i,lanes)==1&LDOWN(i,lanes)==1)
                  changeL(i,lanes)=1;
            end
        end
    end
    %测量是否可以向右变道
    for lanes=3:W-1;
        temp=find(plaza(:,lanes)==1);
        nn=length(temp);
        for k=1:nn;
            i=temp(k);
            if(plaza(i,lanes-1)==0&plaza(mod(i-1-1,L)+1,lanes-1)==0&plaza(mod(i-2-1,L)+1,lanes-1)==0&plaza(mod(i,L)+1,lanes-1)==0&plaza(mod(i+1,L)+1,lanes-1)==0)
                changeR(i,lanes)=1;
            end
        end
    end
    %先向右换道，即可左也可右的时候，选择右
    for lanes=3:W-1;
        temp=find(changeR(:,lanes)==1);
        nn=length(temp);
        for k=1:nn;
            i=temp(k);
            plaza(i,lanes-1)=1;
            v(i,lanes-1)=max(v(i,lanes)-1,1);
            vmax(i,lanes-1)=vmax(i,lanes);
            plaza(i,lanes)=0;
            v(i,lanes)=0;
            vmax(i,lanes)=0;          
            
            changeL(i,lanes)=0;
        end
    end
    %向左换道
    for lanes=2:W-2
        temp=find(changeL(:,lanes)==1);
        nn=length(temp);
        for k=1:nn;
            i=temp(k);
            plaza(i,lanes+1)=1;
            v(i,lanes+1)=max(v(i,lanes)-1,1);
            vmax(i,lanes+1)=vmax(i,lanes);
            plaza(i,lanes)=0;
            v(i,lanes)=0;
            vmax(i,lanes)=0;
        end
    end
end