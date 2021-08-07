clc
clear
close all



[baseName, folder] = uigetfile('*.png');
fullFileName = fullfile(folder, baseName)


I = imread(fullFileName);



I = im2bw(I);
I = 1-I;

image_size = 250;

I = imresize(I, [image_size,image_size]);
I = imrotate(I,180); 
  
        filter_type = 'shepp-logan';
        interpolation_type = 'nearest';

    
  % create the video writer with 1 fps
  writerObj = VideoWriter('myVideo.avi');
  writerObj.FrameRate = 20;
  % set the seconds per image
% open the video writer
open(writerObj);
    
    for i = 1:1:180
        
        tic;
        
        
        R = radon(I,1:i);
        InR = abs(iradon(R,1:i,filter_type,interpolation_type));
        
        zeros = find(InR < 0); 
        InR(zeros) = 0; 
        InR = (i/200)*InR; 
      
        
        
        
  
        
        

        %h = surf(InR);
        set(gcf, 'Position',  [100, 100, 1000, 400])
        subplot(1,2,1) 
        
        InR(find(InR < 0.8)) = 0; 
       
        [C,h] = contourf(InR,10);
        
        title('Resin Kinetic Model'); 
        caxis([0 1])
        set(h,'LineColor','none')
        colorbar
        colormap(jet)
        %set(h,'edgecolor','none') 
        drawnow;
        %writeVideo(writerObj, getframe(gcf));
        
        DOC(i) = length(find(InR > 0.9)) / 6285;
        index_val(i) = i; 
        
        
        
        subplot(1,2,2)
        plot(index_val,DOC,'black','LineWidth',2);
        title('Degree of cure plot'); 
        xlabel('Exposure iteration'); 
        ylabel('Local normalized DOC');
        xlim([0 200]) 
        ylim([0 1])
        hold on; 
        
        
   
        
    end
  



    
  
    
    
    

