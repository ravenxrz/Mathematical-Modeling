function [] = closematlabpool  
   poolobj = gcp('nocreate');  
   delete(poolobj);  
end  