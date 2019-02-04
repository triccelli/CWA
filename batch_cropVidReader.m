list = dir('/Directory/folder/*.mat');

for file_ind = 1:numel(list)

  clear data
  
  fileName = list(file_ind).name;
  disp(['Currently processing: ' fileName]);
  f = fullfile('/Directory', 'folder', fileName)
  
  disp(['Currently processing: ' fileName]);
 
  load(f)
  v = VideoWriter(fileName);
  v.FrameRate = 30;
  v.Quality = 100;
  open(v);

  img = flip(img)

  for k=1:length(img)
      figure(100); subplot(4,1,1:3), imagesc(img{k},[0 200]); axis off; colormap('gray');
      drawnow; 
      frame = getframe(gca);
      writeVideo(v,frame);
  end
  
  close(v);
  
end