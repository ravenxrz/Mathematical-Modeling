function [plaza,v,vmax]=random_slow(plaza,v,vmax,probslow);
    [L,W]=size(plaza);
    for lanes=2:W-1;
        temp=find(plaza(:,lanes)==1);
        nn=length(temp); 
        for k=1:nn;
            i=temp(k);
            if(rand<=probslow)
                v(i,lanes)=max(v(i,lanes)-1,0);
            end
        end
    end
end