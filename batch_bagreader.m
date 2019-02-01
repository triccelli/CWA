
%%frame rate you want it to playback as
framerate = 90;

%%directory 
list = dir('/Users/riccellit/Desktop/*.bag');

for file_ind = 1:numel(list)
    clear data
    fileName = list(file_ind).name;
    disp(['Currently processing: ' fileName]);
    %%if not working, put directory here to make full file name 
    f = fullfile('/Users', 'riccellit', 'Desktop', fileName)

    %open the file 
    bag = rosbag(f);

    %%get info if you want topic name etc. 
    bagInfo = rosbag('info',f);

    %%select your topic, data 
    bSel = select(bag,'Topic','/device_0/sensor_0/Infrared_1/image/data');
    bSel2 = select(bag, 'Topic', '/device_0/sensor_0/Infrared_2/image/data'); 

    %%make a struct of topic data message 
    msgStruct1 = readMessages(bSel,'DataFormat','struct');
    msgStruct2 = readMessages(bSel2, 'DataFormat', 'struct');

    %%read the bits, reshape to image 
    stop = 1;
    cnt = 1;

    for k = 1:numel(msgStruct1)
        %IR1data = msgStruct1{k,1}.Data
        %IR2data = msgStruct2{k,1}.Data
        
        imgHeight = msgStruct1{k,1}.Height;
        imgWidth = msgStruct1{k,1}.Width;
        
        IR1img = reshape(msgStruct1{k,1}.Data, imgWidth, imgHeight);
        IR2img = reshape(msgStruct2{k,1}.Data, imgWidth, imgHeight);
        
        data.IR1(k).img = IR1img;
        data.IR2(k).img = IR2img;
        
    end
        
    tmp=['analyzed' fileName];
    save(tmp,'data','-v7.3');
    disp(['...complete']); 
    
    %% 
    first = strcat('ir1_', fileName(1:10));
    v = VideoWriter(first);
    v.FrameRate = framerate;
    v.Quality = 100;
    open(v);

    for k=1:numel(data.IR1)
        figure(100); subplot(1,2,1); imagesc(data.IR1(k).img,[0 200]); axis off; colormap('gray');
        
        drawnow; 
        frame = getframe(gca);
        writeVideo(v,frame);
    end
    
    second = strcat('ir2_', fileName(1:10));
    v = VideoWriter(second);
    v.FrameRate = framerate;
    v.Quality = 100;
    open(v);

    for k=1:numel(data.IR2)
        figure(100); subplot(1,2,1); imagesc(data.IR2(k).img,[0 200]); axis off; colormap('gray');
        
        drawnow; 
        frame = getframe(gca);
        writeVideo(v,frame);
    end
    
    
        
end

