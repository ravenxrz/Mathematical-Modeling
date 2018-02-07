function OutImg = Normalize(InImg)  
ymax=255;ymin=0;  
xmax = max(max(InImg)); %求得InImg中的最大值  
xmin = min(min(InImg)); %求得InImg中的最小值  
OutImg = round((ymax-ymin)*(InImg-xmin)/(xmax-xmin) + ymin); %归一化并取整  
end 