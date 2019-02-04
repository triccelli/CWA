
%Delete pixel data from files in order to have smaller size 
%ONLY complete after extracting video 

list = dir('/Directory/folder/*.mat');


for file_ind = 1:numel(list)

  clear data
  fileName = list(file_ind).name;
  disp(['Currently processing: ' fileName]);
  
  f = fullfile('/Directory','folder', fileName)
  
  load(f)
  
  [data.frame(1:length(data.frame)).img] = deal([])
  save(f,'data','-v7.3');
  
 end
      
