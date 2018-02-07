clear; 
figure('position',[50 132 900 400],'doublebuffer','on')  
W = []; 
for j=0:7; 
B = 6+j; %number booths 
L = 6; %number lanes in highway before and after plaza 
T = 1; % # hrs to simulate 
global plazalength; 
plazalength = 101; 
plaza = create_plaza(B,L); 
set(gcf,'resize','off') 
PLAZA=rot90(plaza); 
PLAZAA=0.8*ones(40,101,3); 
PLAZA(PLAZA==1)=2; 
PLAZA(PLAZA==0)=1; 
PLAZA(PLAZA==2)=0; 
PLAZA(PLAZA~=0&PLAZA~=1)=0.8; 
PLAZAA(20-ceil(B/2):21+ceil(B/2),:,1)=PLAZA; 
PLAZAA(20-ceil(B/2):21+ceil(B/2),:,2)=PLAZA; 
PLAZAA(20-ceil(B/2):21+ceil(B/2),:,3)=PLAZA; 
H=image(PLAZAA); 
axis off 
entry_vector = create_entry(T,L); 
waiting_time = 0; 
output = 0; 
for i = 1:T*1440 
plaza = move_forward(plaza); %move cars forward 
plaza = new_cars(B, L, plaza, entry_vector(1,i)); %allow new cars to enter 
plaza = switch_lanes(plaza); %allow lane changes 
waiting_time = waiting_time + compute_wait(plaza); %compute waiting time during timestep i 
output = output + compute_output(plaza); 
plaza = clear_boundary(plaza); 
PLAZA=rot90(plaza); 
PLAZA(PLAZA==1)=2; 
PLAZA(PLAZA==0)=1; 
PLAZA(PLAZA==2)=0; 
PLAZA(PLAZA~=0&PLAZA~=1)=0.8; 
PLAZAA(20-ceil(B/2):21+ceil(B/2),:,1)=PLAZA; 
PLAZAA(20-ceil(B/2):21+ceil(B/2),:,2)=PLAZA; 
PLAZAA(20-ceil(B/2):21+ceil(B/2),:,3)=PLAZA; 
plaza50=PLAZAA(:,50,1);plaza50(plaza50==1)=0;PLAZAA(:,50,2)=plaza50;PLAZAA(:,50,3)=plaza50; 
set(H,'CData',PLAZAA); 
set(gcf,'position',[50 132 900 400]) 
pause(0.01) 
end 
plaza; 
W=[W waiting_time] 
end 
